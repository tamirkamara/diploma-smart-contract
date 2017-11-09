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

    function DimplomaWallet(address instManager) {
      Owner = msg.sender;
      state = WalletState.Created;
      InstitutionsManagerAddr = instManager;
    }

    function AddDiploma(address institution, string title) {
      // check that this institue is allowed to add new diplomas
      InstitutionsManager mgr = InstitutionsManager(InstitutionsManagerAddr);
      bool res = mgr.IsAllowedInst(institution);
      if (res == false) {
        revert();
      }

      Diploma memory newDiploma;
      newDiploma.institution = institution;
      newDiploma.title = title;
      newDiploma.state = DiplomaState.PendingApproval;
      Assets.push(newDiploma);
    }

    function ApproveDiploma(uint id) {
        if (msg.sender != Owner) {
            revert();
        }
        if (Assets[id].state != DiplomaState.PendingApproval) {
            revert();
        }

        Assets[id].state = DiplomaState.Approved;
    }

    function RejectDiploma(uint id) {
        if (msg.sender != Owner) {
            revert();
        }
        if (Assets[id].state != DiplomaState.PendingApproval) {
            revert();
        }

        Assets[id].state = DiplomaState.Rejected;
    }

}

///////  

contract InstitutionsManager {

    function InstitutionsManager() {

    }

    // make actual call
    function IsAllowedInst(address instAddress) returns (bool ret) {
        return true;
    }
}