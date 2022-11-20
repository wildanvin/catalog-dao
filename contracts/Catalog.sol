// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

//import {StdStorage} from "../lib/forge-std/src/Components.sol";
import {specific_authenticate_message_params_parse, specific_deal_proposal_cbor_parse} from "./CBORParse.sol";

contract Catalog {
    uint64 public constant AUTHORIZE_MESSAGE_METHOD_NUM = 2643134072;

    mapping(bytes => bool) public cidSet;
    mapping(bytes => uint256) public cidSizes;
    mapping(bytes => mapping(bytes => bool)) public cidProviders;

    //address public owner;
    address[] public owners;
    mapping(address => bool) public isOwner;
    uint256 public numConfirmationsRequired;

    struct Transaction {
        //address to;
        bytes cidraw;
        uint256 size;
        bool executed;
        uint256 numConfirmations;
    }

    mapping(uint256 => mapping(address => bool)) public isConfirmed;
    Transaction[] public transactions;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint256 _txIndex) {
        require(_txIndex < transactions.length, "tx does not exist");
        _;
    }

    modifier notExecuted(uint256 _txIndex) {
        require(!transactions[_txIndex].executed, "tx already executed");
        _;
    }

    modifier notConfirmed(uint256 _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender], "tx already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
        require(_owners.length > 0, "owners required");
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "invalid number of required confirmations"
        );
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }
        numConfirmationsRequired = _numConfirmationsRequired;
    }

    receive() external payable {
        //emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(bytes memory _cidraw, uint256 _size) public onlyOwner {
        transactions.push(
            Transaction({cidraw: _cidraw, size: _size, executed: false, numConfirmations: 0})
        );
    }

    function confirmTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
        notConfirmed(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];
        transaction.numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;
    }

    function executeTransaction(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        require(transaction.numConfirmations >= numConfirmationsRequired, "cannot execute tx");

        transaction.executed = true;

        addCID(transaction.cidraw, transaction.size);

        //(bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        //require(success, "tx failed");
        //emit ExecuteTransaction(msg.sender, _txIndex);
    }

    function revokeConfirmation(uint256 _txIndex)
        public
        onlyOwner
        txExists(_txIndex)
        notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender], "tx not confirmed");

        transaction.numConfirmations -= 1;
        isConfirmed[_txIndex][msg.sender] = false;
    }

    function getOwners() public view returns (address[] memory) {
        return owners;
    }

    function getTransactionCount() public view returns (uint256) {
        return transactions.length;
    }

    function getTransaction(uint256 _txIndex)
        public
        view
        returns (
            bytes memory cidraw,
            uint256 size,
            bool executed,
            uint256 numConfirmations
        )
    {
        Transaction storage transaction = transactions[_txIndex];

        return (
            transaction.cidraw,
            transaction.size,
            transaction.executed,
            transaction.numConfirmations
        );
    }

    function addCID(bytes memory cidraw, uint256 size) internal {
        //require(msg.sender == owner);
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
    ) internal {
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
