// use starknet::{ContractAddress}

#[starknet::contract]
pub mod Land {
    use core::num::traits::zero::Zero;
    use core::traits::{TryInto, Into};
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
        lands: LegacyMap<felt252, ByteArray>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        OwnableEvent: OwnableComponent::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState, owner: ContractAddress) {
        assert(!owner.is_zero(), ZERO_CALLER_ADDRESS);
        self.ownable.initializer(owner);
    // might emit event here 
    }
}
