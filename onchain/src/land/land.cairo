// use starknet::{ContractAddress}

#[starknet::contract]
pub mod Land {
    use core::num::traits::zero::Zero;
    use core::traits::{TryInto, Into};
    use core::byte_array::ByteArray;
    use core::poseidon::PoseidonTrait;
    use core::hash::{HashStateTrait, HashStateExTrait};
    use core::byte_array::ByteArrayTrait;
    use starknet::{ContractAddress, get_caller_address};
    use landstamp::interfaces::ILand::ILands;
    use landstamp::base::types::{LandParams};
    use landstamp::base::errors::Errors::{ZERO_ADDRESS_CALLER, ZERO_ADDRESS_OWNER, NOT_OWNER};
    use openzeppelin::access::ownable::OwnableComponent;

    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);

    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;

    #[storage]
    struct Storage {
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        lands: LegacyMap<felt252, felt252>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        LandRegistered: LandRegistered
    }

    #[derive(Drop, starknet::Event)]
    struct LandRegistered {
        pub land_id: felt252,
        pub land_id_hash: felt252,
    }


    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        assert(!owner.is_zero(), ZERO_ADDRESS_CALLER);
        self.ownable.initializer(owner);
    // might emit event here 
    }

    #[abi(embed_v0)]
    impl LandImpl of ILands<ContractState> {
        fn verify_land(self: @ContractState, land_id: felt252) -> LandParams {
            let land_id_hash = self.lands.read(land_id);

            if (land_id_hash != 0) {
                let land_details = LandParams { land_id: land_id, land_id_hash: land_id_hash };
                return land_details;
            }
            let land_details = LandParams { land_id: land_id, land_id_hash: land_id_hash };
            land_details
        }

        fn register_land(ref self: ContractState, land_id: felt252, land_id_hash: felt252) {
            self.ownable.assert_only_owner();
            // i need to copy land_id_hash in order to use it inside LandRegistered event emit
            let event_land_id_hash = PoseidonTrait::new().update(land_id).finalize();
            self.lands.write(land_id, land_id_hash);
            // dispatch event
            self.emit(LandRegistered { land_id: land_id, land_id_hash: event_land_id_hash });
        // use subgraph to listen to this event emitted
        }
    }
}
