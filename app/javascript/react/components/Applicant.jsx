import React, { useState } from "react";

import CreationCell from "./applicant/CreationCell";
import InvitationCells from "./applicant/InvitationCells";
import ContactInfosExtraLine from "./applicant/ContactInfosExtraLine";
import ReferentAssignationCell from "./applicant/ReferentAssignationCell";

export default function Applicant({ applicant, isDepartmentLevel, showReferentColumn }) {
  const [isTriggered, setIsTriggered] = useState({
    creation: false,
    unarchive: false,
    smsInvitation: false,
    emailInvitation: false,
    postalInvitation: false,
    referentAssignation: false,
    emailUpdate: false,
    phoneNumberUpdate: false,
    rightsOpeningDateUpdate: false,
    allAttributesUpdate: false,
  });

  const computeInvitationsColspan = () => {
    let colSpan = 0;
    if (applicant.canBeInvitedBy("sms")) colSpan += 1;
    if (applicant.canBeInvitedBy("email")) colSpan += 1;
    if (applicant.canBeInvitedBy("postal")) colSpan += 1;
    return colSpan;
  };

  return (
    <>
      <tr className={applicant.isArchivedInCurrentDepartment() ? "table-danger" : ""}>
        <td>{applicant.shortTitle}</td>
        <td>{applicant.firstName}</td>
        <td>{applicant.lastName}</td>
        {applicant.shouldDisplay("affiliation_number_column") && (
          <td>{applicant.affiliationNumber ?? " - "}</td>
        )}
        {applicant.shouldDisplay("role_column") && <td>{applicant.shortRole ?? " - "}</td>}
        {applicant.shouldDisplay("department_internal_id_column") && (
          <td>{applicant.departmentInternalId ?? " - "}</td>
        )}
        {applicant.shouldDisplay("email_column") && (
          <td className={applicant.emailUpdated ? "table-success" : ""}>
            {applicant.email ?? " - "}
          </td>
        )}
        {applicant.shouldDisplay("phone_number_column") && (
          <td className={applicant.phoneNumberUpdated ? "table-success" : ""}>
            {applicant.phoneNumber ?? " - "}
          </td>
        )}
        {applicant.shouldDisplay("rights_opening_date_column") && (
          <td className={applicant.rightsOpeningDateUpdated ? "table-success" : ""}>
            {applicant.rightsOpeningDate ?? " - "}
          </td>
        )}
        {applicant.shouldDisplay("nir_column") && <td>{applicant.nir ?? " - "}</td>}
        {applicant.shouldDisplay("pole_emploi_id_column") && (
          <td>{applicant.poleEmploiId ?? " - "}</td>
        )}
        {/* ------------------------------- Account creation cell ----------------------------- */}

        <CreationCell
          applicant={applicant}
          isDepartmentLevel={isDepartmentLevel}
          isTriggered={isTriggered}
          setIsTriggered={setIsTriggered}
        />

        {/* ------------------------------- Referent cell ----------------------------- */}

        {showReferentColumn && (
          <ReferentAssignationCell
            applicant={applicant}
            isDepartmentLevel={isDepartmentLevel}
            isTriggered={isTriggered}
            setIsTriggered={setIsTriggered}
          />
        )}

        {/* --------------------------------- Invitations cells ------------------------------- */}
        {applicant.currentConfiguration && (
          <InvitationCells
            applicant={applicant}
            invitationsColspan={computeInvitationsColspan()}
            isDepartmentLevel={isDepartmentLevel}
            isTriggered={isTriggered}
            setIsTriggered={setIsTriggered}
          />
        )}
      </tr>

      {/* Contact infos extra line. It appears if the applicant contacts data when uploading the contacts file are different from the ones in DB */}

      {(applicant.phoneNumberNew || applicant.emailNew || applicant.rightsOpeningDateNew) && (
        <ContactInfosExtraLine
          applicant={applicant}
          invitationsColspan={computeInvitationsColspan()}
          isTriggered={isTriggered}
          setIsTriggered={setIsTriggered}
        />
      )}
    </>
  );
}
