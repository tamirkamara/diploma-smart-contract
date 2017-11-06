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

    address public InstitutionsManager;
    address public Owner;
	string public StudentFirstName;
    string public StudentLastName;

	Diploma[] public Assets;
    WalletState public state;

    function DimplomaWallet() {
      Owner = msg.sender;
      state = WalletState.Created;
      InstitutionsManager = 0x0;
    }

    function AddDiploma(address institution, string title) {
      // check that this institue is allowed to add new diplomas
      // InstitutionsManager.call(bytes4(sha3("IsAllowedInst(address)")), institution);
      // if false then revert...
      Diploma newDiploma;
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
