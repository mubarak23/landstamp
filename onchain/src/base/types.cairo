use core::serde::Serde;
use core::option::OptionTrait;

#[derive(Drop, Serde, starknet::Store, Clone)]
pub struct LandParams {
    pub land_id: felt252,
    pub land_id_hash: ByteArray, // onchain cloud storage id 
}
