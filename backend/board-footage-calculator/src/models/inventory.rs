use rust_decimal::Decimal;
use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use uuid::Uuid;

#[derive(Debug, Serialize, FromRow)]
pub struct Inventory {
    pub id: Uuid,
    pub species: String,

    #[serde(with = "rust_decimal::serde::float")]
    pub board_feet: Decimal,
}

#[derive(Debug, Deserialize)]
pub struct InventoryRequest {
    pub species: String,
    pub board_feet: Decimal,
}