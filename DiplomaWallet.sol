pragma solidity ^0.4.10;

contract DimplomaWallet {

    enum WalletState { Created, Terminated }
	enum DiplomaState { PendingApproval, Approved, Rejected }
    struct Diploma {
      address institution;
      string title;
      DiplomaState state;
      // todo: for signing the content
      string hashCode;
    }

    address public InstitutionsManagerAddr;
    address public Owner;
	string public StudentFirstName;
    string public StudentLastName;

	Diploma[] public Assets;
    WalletState public state;

    // Ctor
    function DimplomaWallet(address instManager) {
      Owner = msg.sender;
      state = WalletState.Created;
      InstitutionsManagerAddr = instManager;
    }

    function AddDiploma(string title) {
      // check that this institue is allowed to add new diplomas
      InstitutionsManager mgr = InstitutionsManager(InstitutionsManagerAddr);
      bool res = mgr.IsAllowedInst(msg.sender);
      if (res == false) {
        revert();
      }
 
      // Create a new diploma object and push it into the users diploma's list
      Diploma memory newDiploma;
      newDiploma.institution = msg.sender;
      newDiploma.title = title;
      newDiploma.state = DiplomaState.PendingApproval;
      Assets.push(newDiploma);
    }

    function ApproveDiploma(uint id) {
        if (msg.sender != Owner) {
            revert();
        }

        // invalid id
        if (Assets.length - 1 < id) {
            revert();
        }

        //  only allow approving diplomas which are pending approval
        if (Assets[id].state != DiplomaState.PendingApproval) {
            revert();
        }

        Assets[id].state = DiplomaState.Approved;
    }

    function RejectDiploma(uint id) {
        if (msg.sender != Owner) {
            revert();
        }

        // invalid id
        if (Assets.length - 1 < id) {
            revert();
        }
        
        //  only allow rejecting diplomas which are pending approval
        if (Assets[id].state != DiplomaState.PendingApproval) {
            revert();
        }

        Assets[id].state = DiplomaState.Rejected;
    }

}

///////  

contract InstitutionsManager {

  mapping (address => bool) addressToIsAllowed;
  address Owner;

  function InstitutionsManager() {
    Owner = msg.sender;
  }

  function IsAllowedInst(address instAddress) returns (bool ret) {
    return addressToIsAllowed[instAddress];
  }

  function ApproveInstitution(address instAddress) {
    if (msg.sender != Owner) {
      revert();
    }
      
    addressToIsAllowed[instAddress] = true;
  }
}