pragma solidity ^0.4.10;

contract AddDiploma {

	enum DiplomaState { PendingApproval, Approved, Rejected, Cancelled }

	address public Student;
	address public Institution;
	string public Title;
    DiplomaState public State;

    function AddDiploma(string title, address student, address institution) {
        Student = student;
        Institution = institution;
        Title = title;

        if (msg.sender == institution) {
            State = DiplomaState.Approved;
        } else {
            State = DiplomaState.PendingApproval;
        }
    }

    function ApproveDiploma() {
        if (msg.sender == Institution && State == DiplomaState.PendingApproval) {
            State = DiplomaState.Approved;
        } else {
            revert();
        }
    }

    function RejectDiploma() {
        if (msg.sender == Institution && State == DiplomaState.PendingApproval) {
            State = DiplomaState.Rejected;
        } else {
            revert();
        }
    }

    function CancelDiplomaRequest() {
        if (msg.sender == Student && State == DiplomaState.PendingApproval) {
            State = DiplomaState.Cancelled;
         } else {
            revert();
        }
    }
}
