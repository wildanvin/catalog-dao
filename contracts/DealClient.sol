// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//import {StdStorage} from "../lib/forge-std/src/Components.sol";
import {specific_authenticate_message_params_parse, specific_deal_proposal_cbor_parse} from "./CBORParse.sol";

contract DealClient {
    uint64 public constant AUTHORIZE_MESSAGE_METHOD_NUM = 2643134072;

    mapping(bytes => bool) public cidSet;
    mapping(bytes => uint256) public cidSizes;
    mapping(bytes => mapping(bytes => bool)) public cidProviders;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function addCID(bytes calldata cidraw, uint256 size) public {
        require(msg.sender == owner);
        cidSet[cidraw] = true;
        cidSizes[cidraw] = size;
    }

    function policyOK(bytes calldata cidraw, bytes calldata provider) internal view returns (bool) {
        bool alreadyStoring = cidProviders[cidraw][provider];
        return !alreadyStoring;
    }

    function authorizeData(
        bytes calldata cidraw,
        bytes calldata provider,
        uint256 size
    ) public {
        // if (msg.sender != f05) return;
        require(cidSet[cidraw], "cid must be added before authorizing");
        require(cidSizes[cidraw] == size, "data size must match expected");
        require(
            policyOK(cidraw, provider),
            "deal failed policy check: has provider already claimed this cid?"
        );

        cidProviders[cidraw][provider] = true;
    }

    function handle_filecoin_method(
        uint64,
        uint64 method,
        bytes calldata params
    ) public {
        // dispatch methods
        if (method == AUTHORIZE_MESSAGE_METHOD_NUM) {
            bytes calldata deal_proposal_cbor_bytes = specific_authenticate_message_params_parse(
                params
            );
            (
                bytes calldata cidraw,
                bytes calldata provider,
                uint256 size
            ) = specific_deal_proposal_cbor_parse(deal_proposal_cbor_bytes);
            authorizeData(cidraw, provider, size);
        } else {
            revert("the filecoin method that was called is not handled");
        }
    }
}
