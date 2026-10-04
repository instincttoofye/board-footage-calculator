mod models;
mod routes;

use axum::{
    Router,
    routing::{get, post}
};

use sqlx::postgres::PgPoolOptions;

use routes::inventory::{add_inventory, get_inventory, subtract_inventory};

#[tokio::main]
async fn main() {
    let path = dotenvy::dotenv()
        .expect("Could not load .env file");

    println!("Loaded env from: {}", path.display());

    let database_url = std::env::var("DATABASE_URL").expect("DATABASE_URL must be set");

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await
        .expect("YOU DIDNT CONNECT TO THE DB STOOPID");

    let app = Router::new()
        .route("/inventory",get(get_inventory))
        .route("/inventory/add", post(add_inventory))
        .route("/inventory/subtract", post(subtract_inventory))
        .with_state(pool);

    let listener = tokio::net::TcpListener::bind(
        "0.0.0.0:3060",
    )
    .await
    .unwrap();

    println!("Board Footage backend on 3060");

    axum::serve(listener, app)
    .await
    .unwrap();
}
