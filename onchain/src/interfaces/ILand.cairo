use landstamp::base::types::{LandParams};

#[starknet::interface]
pub trait ILands<TContractState> {
    fn verify_land(self: @TContractState, land_id: felt252) -> LandParams;
    fn register_land(ref self: TContractState, land_id: felt252, land_id_hash: felt252);
}

