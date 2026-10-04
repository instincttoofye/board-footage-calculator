use axum::{
    extract::State,
    http::StatusCode,
    Json,
};

use sqlx::PgPool;

use crate::models::inventory::{
    InventoryRequest,
    Inventory,
};

pub async fn get_inventory(
    State(pool): State<PgPool>,
) -> Result<Json<Vec<Inventory>>, StatusCode> {
    let inventory = sqlx::query_as::<_, Inventory>(
        r#"
        SELECT id, species, board_feet
        FROM board_footage
        ORDER BY species
        "#,
    )
    .fetch_all(&pool)
    .await
    .map_err(|error| {
        eprintln!("Failed to get inventory: {error}");
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    Ok(Json(inventory))
}

pub async fn add_inventory(
    State(pool): State<PgPool>,
    Json(input): Json<InventoryRequest>,
) -> Result<Json<Inventory>, StatusCode> {
    let inventory = sqlx::query_as::<_, Inventory>(
        r#"
        INSERT INTO board_footage (species, board_feet)
        VALUES ($1, $2)

        ON CONFLICT (species)
        DO UPDATE SET
            board_feet = board_footage.board_feet + EXCLUDED.board_feet

        RETURNING id, species, board_feet
        "#,
    )
    .bind(input.species)
    .bind(input.board_feet)
    .fetch_one(&pool)
    .await
    .map_err(|error| {
        eprintln!("Failed to add inventory: {error}");
        StatusCode::INTERNAL_SERVER_ERROR
    })?;

    Ok(Json(inventory))
}

pub async fn subtract_inventory(
    State(pool): State<PgPool>,
    Json(payload): Json<InventoryRequest>,
) -> Result<Json<Inventory>, StatusCode> {
    let inventory = sqlx::query_as::<_, Inventory>(
        r#"
        UPDATE board_footage
        SET board_feet = board_feet - $2
        WHERE species = $1
          AND board_feet >= $2
        RETURNING id, species, board_feet
        "#,
    )
    .bind(&payload.species)
    .bind(payload.board_feet)
    .fetch_optional(&pool)
    .await
    .map_err(|_| StatusCode::INTERNAL_SERVER_ERROR)?;

    match inventory {
        Some(inventory) => Ok(Json(inventory)),
        None => Err(StatusCode::BAD_REQUEST),
    }
}