-- Oracle conversion script - 1.3 to 1.4 
alter table EVAL_EVALUATION add (LOCAL_SELECTOR varchar2(255 char));

update eval_email_template set template_type='ConsolidatedAvailable' where template_type='SingleEmailAvailable';
update eval_email_template set template_type='ConsolidatedReminder' where template_type='SingleEmailReminder';

create table EVAL_EMAIL_PROCESSING_QUEUE 
(
	ID number(19,0) not null, 
	EAU_ID number(19,0),  
	USER_ID varchar2(255), 
	GROUP_ID varchar2(255),
	EMAIL_TEMPLATE_ID number(19,0), 
	EVAL_DUE_DATE timestamp(6), 
	PROCESSING_STATUS number(4,0), 
	primary key (ID)
);

create index EVAL_EPQ_UITI_IDX on EVAL_EMAIL_PROCESSING_QUEUE (EMAIL_TEMPLATE_ID,USER_ID); 

alter table EVAL_ASSIGN_USER add AVAILABLE_EMAIL_SENT timestamp(6) DEFAULT NULL;
alter table EVAL_ASSIGN_USER add REMINDER_EMAIL_SENT timestamp(6) DEFAULT NULL;
create index ASSIGN_USER_AES_IDX on EVAL_ASSIGN_USER (AVAILABLE_EMAIL_SENT);
create index ASSIGN_USER_RES_IDX on EVAL_ASSIGN_USER (REMINDER_EMAIL_SENT);

insert into EVAL_CONFIG (ID,LAST_MODIFIED, NAME, VALUE) VALUES (hibernate_sequence.NEXTVAL,CURRENT_TIMESTAMP(6),'CONSOLIDATED_EMAIL_NOTIFY_AVAILABLE',1);

alter table eval_evaluation add  (AVAILABLE_EMAIL_SENT NUMBER(1,0));

alter table EVAL_EVALUATION add (INSTRUCTOR_VIEW_ALL_RESULTS NUMBER(1,0));
alter table EVAL_ASSIGN_HIERARCHY add (INSTRUCTORS_VIEW_ALL_RESULTS NUMBER(1,0));
alter table EVAL_ASSIGN_GROUP add (INSTRUCTORS_VIEW_ALL_RESULTS NUMBER(1,0));