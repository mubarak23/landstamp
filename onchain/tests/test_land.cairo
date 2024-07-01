use core::option::OptionTrait;
use core::traits::{TryInto, Into};
use core::starknet::SyscallResultTrait;
use openzeppelin::access::ownable::interface::{IOwnableDispatcher, IOwnableDispatcherTrait};
use starknet::{ContractAddress, class_hash::ClassHash, contract_address_const};
use snforge_std::{
    declare, ContractClassTrait, start_prank, stop_prank,CheatTarget
};
use landstamp::interfaces::ILand::{ILandsDispatcher, ILandsDispatcherTrait};
use landstamp::base::types::{LandParams};

const USER_ONE_ADDR: felt252 = 0x2;
const OWNER_ADDR: felt252 = 0x1;
const ZERO_ADDR: felt252 = 0x0;

fn __setupdeploy__ (owner: felt252)-> ContractAddress {
    let land_contract = declare("Land").unwrap();
    let mut land_constructor_calldata = array![owner];
    let (land_contract_address, _) = land_contract.deploy(@land_constructor_calldata).unwrap_syscall();
    land_contract_address

}


#[test]
fn test_get_owner() {
    let land_contract_address = __setupdeploy__(OWNER_ADDR);
    let owner_dispatcher = IOwnableDispatcher { contract_address: land_contract_address};

    // start_cheat_caller_address(land_contract_address, USER_ONE_ADDR.try_into().unwrap());
    start_prank(CheatTarget::One(land_contract_address), USER_ONE_ADDR.try_into().unwrap());
    let owner = owner_dispatcher.owner();
    assert(owner == OWNER_ADDR.try_into().unwrap(), 'Not the owner, Donnot try this');

    // stop_cheat_caller_address(land_contract_address);
     stop_prank(CheatTarget::One(land_contract_address));

}