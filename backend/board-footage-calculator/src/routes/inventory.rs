use axum::{
    extract::State,
    http::StatusCode,
    Json,
};

use sqlx::PgPool;

use crate::models::inventory::{
    AddInventory,
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
    Json(input): Json<AddInventory>,
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