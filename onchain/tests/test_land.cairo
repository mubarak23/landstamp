use core::option::OptionTrait;
use core::traits::{TryInto, Into};
use core::starknet::SyscallResultTrait;
use openzeppelin::access::ownable::interface::{IOwnableDispatcher, IOwnableDispatcherTrait};
use starknet::{ContractAddress, class_hash::ClassHash, contract_address_const};
use snforge_std::{
    declare, ContractClassTrait, start_cheat_caller_address, stop_cheat_caller_address
};
use landstamp::interfaces::ILand::{ILandsDispatcher, ILandsDispatcherTrait};
use landstamp::base::types::{LandParams};

fn __setupdeploy__ (owner: felt252)-> ContractAddress {
    let land_contract = declare("Land").unwrap();
    let mut land_constructor_calldata = array![owner];
    let (land_contract_address, _) = land_contract.deploy(@land_constructor_calldata).unwrap_syscall();
    land_contract_address

}


