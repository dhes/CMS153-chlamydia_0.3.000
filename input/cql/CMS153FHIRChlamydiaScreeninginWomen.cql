library CMS153FHIRChlamydiaScreeninginWomen version '0.3.001'

using QICore version '6.0.0'

include FHIRHelpers version '4.4.000' called FHIRHelpers
include QICoreCommon version '4.0.000' called QICoreCommon
include SupplementalDataElements version '5.1.000' called SDE
include Hospice version '6.15.001' called Hospice
include CumulativeMedicationDuration version '6.0.001' called CMD
include Status version '1.13.000' called Status

codesystem "AdministrativeGender": 'http://terminology.hl7.org/CodeSystem/v3-AdministrativeGender'
codesystem "LOINC": 'http://loinc.org'
codesystem "SNOMEDCT": 'http://snomed.info/sct'

valueset "Chlamydia Screening": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1052'
valueset "Complications of Pregnancy, Childbirth and the Puerperium": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1012'
valueset "Contraceptive Medications": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1080'
valueset "Diagnoses Used to Indicate Sexual Activity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1018'
valueset "Diagnostic Studies During Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1008'
valueset "HIV": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.120.12.1003'
valueset "Home Healthcare Services": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1016'
valueset "Isotretinoin": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.196.12.1143'
valueset "Lab Tests During Pregnancy": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1007'
valueset "Lab Tests for Sexually Transmitted Infections": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.110.12.1051'
valueset "Office Visit": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1001'
valueset "Virtual Encounter": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1089'
valueset "Pap Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.108.12.1017'
valueset "Pregnancy Test": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1011'
valueset "Preventive Care Services Established Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1025'
valueset "Preventive Care Services Initial Office Visit, 18 and Up": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1023'
valueset "Preventive Care Services, Initial Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1022'
valueset "Preventive Care, Established Office Visit, 0 to 17": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1024'
valueset "Procedures Used to Indicate Sexual Activity": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.111.12.1017'
valueset "Telephone Visits": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.101.12.1080'
valueset "XRay Study": 'http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.464.1003.198.12.1034'

code "Female": 'F' from "AdministrativeGender" display 'Female'
code "Have you ever had vaginal intercourse [PhenX]": '64728-9' from "LOINC" display 'Have you ever had vaginal intercourse [PhenX]'
code "Yes (qualifier value)": '373066001' from "SNOMEDCT" display 'Yes (qualifier value)'

parameter "Measurement Period" Interval<DateTime> // default Interval[@2026-01-01T00:00:00, @2026-12-31T23:59:59]

context Patient

define "SDE Ethnicity":
  SDE."SDE Ethnicity"

define "SDE Payer":
  SDE."SDE Payer"

define "SDE Race":
  SDE."SDE Race"

define "SDE Sex":
  SDE."SDE Sex"

define "Initial Population":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  ) in Interval[16, 24]
    and Patient.gender = 'female'
    and exists ( "Qualifying Encounters" )
    and ( ( "Has Assessments Identifying Sexual Activity" )
        or ( "Has Diagnoses Identifying Sexual Activity" )
        or ( "Has Active Contraceptive Medications" )
        or ( "Has Ordered Contraceptive Medications" )
        or ( "Has Laboratory Tests Identifying Sexual Activity" )
        or ( "Has Diagnostic Studies Identifying Sexual Activity" )
        or ( "Has Procedures Identifying Sexual Activity" )
    )

define "Qualifying Encounters":
  ( ( [Encounter: "Office Visit"]
      union [Encounter: "Preventive Care Services Established Office Visit, 18 and Up"]
      union [Encounter: "Preventive Care Services Initial Office Visit, 18 and Up"]
      union [Encounter: "Preventive Care Services, Initial Office Visit, 0 to 17"]
      union [Encounter: "Preventive Care, Established Office Visit, 0 to 17"]
      union [Encounter: "Home Healthcare Services"]
      union [Encounter: "Telephone Visits"]
      union [Encounter: "Virtual Encounter"]
  ).isEncounterPerformed ( ) ) ValidEncounters
    where ValidEncounters.period.toInterval ( ) during day of "Measurement Period"

define "Has Diagnoses Identifying Sexual Activity":
  exists ( ( [ConditionEncounterDiagnosis: "Diagnoses Used to Indicate Sexual Activity"] ESA
      union [ConditionProblemsHealthConcerns: "Diagnoses Used to Indicate Sexual Activity"] PSA
      union [ConditionEncounterDiagnosis: "HIV"] EHIV
      union [ConditionProblemsHealthConcerns: "HIV"] PHIV
      union [ConditionEncounterDiagnosis: "Complications of Pregnancy, Childbirth and the Puerperium"] EPCP
      union [ConditionProblemsHealthConcerns: "Complications of Pregnancy, Childbirth and the Puerperium"] PPCP ) SexualActivityDiagnosis
      where SexualActivityDiagnosis.prevalenceInterval ( ) overlaps "Measurement Period"
  )

define "Has Active Contraceptive Medications":
  exists ( ( [MedicationRequest: "Contraceptive Medications"] ).isMedicationActive ( ) ) ActiveContraceptives
    where ActiveContraceptives.medicationRequestPeriod ( ) overlaps "Measurement Period"

define "Has Ordered Contraceptive Medications":
  exists ( ( [MedicationRequest: "Contraceptive Medications"] ).isMedicationOrder ( ) ) OrderedContraceptives
    where OrderedContraceptives.authoredOn.toInterval ( ) during day of "Measurement Period"

define "Has Laboratory Tests Identifying Sexual Activity But Not Pregnancy":
  exists ( ( [ServiceRequest: "Pap Test"]
      union [ServiceRequest: "Lab Tests During Pregnancy"]
      union [ServiceRequest: "Lab Tests for Sexually Transmitted Infections"]
  ).isLaboratoryTestOrder ( ) ) LabOrders
    where LabOrders.authoredOn.toInterval ( ) during day of "Measurement Period"

define "Has Laboratory Tests Identifying Sexual Activity":
  exists ( ( ( [ServiceRequest: "Pregnancy Test"] ).isLaboratoryTestOrder ( ) ) PregnancyTest
      where PregnancyTest.authoredOn.toInterval ( ) during day of "Measurement Period"
  )
    or "Has Laboratory Tests Identifying Sexual Activity But Not Pregnancy"

define "Has Diagnostic Studies Identifying Sexual Activity":
  exists ( ( [ServiceRequest: "Diagnostic Studies During Pregnancy"] ).isDiagnosticStudyOrder ( ) ) SexualActivityDiagnostics
    where SexualActivityDiagnostics.authoredOn.toInterval ( ) during day of "Measurement Period"

define "Has Procedures Identifying Sexual Activity":
  exists ( ( [Procedure: "Procedures Used to Indicate Sexual Activity"] ).isProcedurePerformed ( ) ) ProceduresForSexualActivity
    where ProceduresForSexualActivity.performed.toInterval ( ) during day of "Measurement Period"

define "Denominator":
  "Initial Population"

define "Denominator Exclusions":
  Hospice."Has Hospice Services"
    or ( ( "Has Pregnancy Test Exclusion" )
        and not ( "Has Assessments Identifying Sexual Activity" )
        and not ( "Has Diagnoses Identifying Sexual Activity" )
        and not ( "Has Active Contraceptive Medications" )
        and not ( "Has Ordered Contraceptive Medications" )
        and not ( "Has Laboratory Tests Identifying Sexual Activity But Not Pregnancy" )
        and not ( "Has Diagnostic Studies Identifying Sexual Activity" )
        and not ( "Has Procedures Identifying Sexual Activity" )
    )

// define HasIntervalTest: Interval[@2026-01-01T00:00:00, @2026-01-01T00:00:00] during Interval[@2026-01-01T00:00:00, @2026-12-31T23:59:59] 

define "Has Pregnancy Test Exclusion":
  exists ( ( ( ( [ServiceRequest: "Pregnancy Test"] ).isLaboratoryTestOrder ( ) ) PregnancyTest
        with ( ( [ServiceRequest: "XRay Study"] ).isDiagnosticStudyOrder ( ) ) XrayOrder
          such that XrayOrder.authoredOn.toInterval ( ) occurs 6 days or less on or after day of PregnancyTest.authoredOn.toInterval ( )
        where PregnancyTest.authoredOn.toInterval ( ) during "Measurement Period"
    )
      union ( ( [ServiceRequest: "Pregnancy Test"] ).isLaboratoryTestOrder ( ) ) PregnancyTestOrder
        with ( ( [MedicationRequest: "Isotretinoin"] ).isMedicationOrder ( ) ) AccutaneOrder
          such that AccutaneOrder.authoredOn.toInterval ( ) occurs 6 days or less on or after day of PregnancyTestOrder.authoredOn.toInterval ( )
        where PregnancyTestOrder.authoredOn.toInterval ( ) during "Measurement Period"
  )

define "Numerator":
  exists ( ( ( [LaboratoryResultObservation: "Chlamydia Screening"] ).isLaboratoryTestPerformed ( ) ) ChlamydiaTest
      where ChlamydiaTest.effective.latest ( ) during day of "Measurement Period"
        and ChlamydiaTest.value is not null
  )

define "Stratification 1":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  ) in Interval[16, 20]

define "Stratification 2":
  AgeInYearsAt(date from 
    end of "Measurement Period"
  ) in Interval[21, 24]

define "Has Assessments Identifying Sexual Activity":
  exists ( ( ( [ObservationScreeningAssessment: "Have you ever had vaginal intercourse [PhenX]"] ).isAssessmentPerformed ( ) ) SexualActivityAssessment
      where SexualActivityAssessment.value ~ "Yes (qualifier value)"
        and SexualActivityAssessment.effective.toInterval ( ) on or before end of "Measurement Period"
  )