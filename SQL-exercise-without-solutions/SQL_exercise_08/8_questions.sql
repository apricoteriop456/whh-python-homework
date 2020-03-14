-- 8.1 Obtain the names of all physicians that have performed a medical procedure they have never been certified to perform.
create view temp1 
as
(select * 
from physician inner join 
    (
    select * from 
    (select (cast(physician as varchar)||cast(procedures as varchar)) as pp,
    --由于有外键设置，无法直接改变字段类型，而且视图不接受使用distinct(physician,procedures)生成的字段类型，使用cast起到临时改变数据类型的作用
    physician,procedures,patient,dateundergoes from undergoes) as a 
    --1.找到每个医生完成的手术
    where a.pp not in 
        (select (cast(undergoes.physician as varchar)||cast(procedures as varchar))
        from undergoes inner join trained_in on undergoes.procedures=trained_in.treatment and undergoes.physician=trained_in.physician)
        --2.先将undergoes与trainedin连接,连接字段为physician和precedure,这样可以找到每个医生完成的已经认证的手术。
        )as b 
--3.通过in寻找,然后找到相应的名字
on physician.employeeid=b.physician);

select name from temp1;
-- 8.2 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on.
--方法一：
select physician.name as phy_name,procedures.name as pro_name,b.dateundergoes,patient.name as pat_name 
from physician inner join 
    (
    select * from 
    (select distinct(physician,procedures)as pp ,physician,procedures,patient,dateundergoes from undergoes) as a 
    --1.找到每个医生完成的手术
    where a.pp not in 
        (select distinct(undergoes.physician,procedures) 
        from undergoes inner join trained_in on undergoes.procedures=trained_in.treatment and undergoes.physician=trained_in.physician)
        --2.先将undergoes与trainedin连接,连接字段为physician和precedure,这样可以找到每个医生完成的已经认证的手术。
        )as b 
--3.通过in寻找,然后找到相应的名字
on physician.employeeid=b.physician
inner join procedures on procedures.code = b.procedures
--注意与patient连接时，同一个医生可以负责很多个病人，所以连接字段要加上主治医生
inner join patient on (patient.SSN = b.patient and patient.pcp=b.physician);

-- 方法二：
select temp1.name as phy_name,procedures.name as pro_name,temp1.dateundergoes,patient.name as pat_name 
from temp1 inner join procedures on procedures.code = temp1.procedures
--注意与patient连接时，同一个医生可以负责很多个病人，所以连接字段要加上主治医生
inner join patient on (patient.SSN = temp1.patient and patient.pcp=temp1.physician);


-- 8.3 Obtain the names of all physicians that have performed a medical procedure that they are certified to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).
create view temp2
as
(select patient,procedures,stay,dateundergoes,undergoes.physician,assistingnurse,certificationdate,certificationexpires
from undergoes inner join trained_in on undergoes.procedures=trained_in.treatment and undergoes.physician=trained_in.physician
--将undergoes与trainedin连接,连接字段为physician和precedure,这样可以找到每个医生完成的已经认证的手术。
where dateundergoes > certificationexpires
);

select name from temp2 inner join physician on temp2.physician=physician.employeeid;

-- 8.4 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on, and date when the certification expired.
select physician.name as phy_name,procedures.name as pro_name,dateundergoes,patient.name as pat_name,certificationexpires 
from temp2 
inner join physician on physician.employeeid=temp2.physician
inner join patient on patient.ssn=temp2.patient
inner join procedures on procedures.code = temp2.procedures
;

-- 8.5 Obtain the information for appointments where a patient met with a physician other than his/her primary care physician. Show the following information: Patient name, physician name, nurse name (if any), start and end time of appointment, examination room, and the name of the patient's primary care physician.
--1.通过构建临时表的方式先找到每个病人的主治医生(在patient的pcp),在appointment中剔除该条信息,用<>
--2.再与其他表连接
select * into temp3 from patient inner join
(select *,row_number() over (partition by patient) from appointment) as a on a.patient=patient.ssn
where pcp<>physician; 

select patient.name as pat_name,a.name as phy_name,
nurse.name as nur_name,starts,ends,examinationroom,b.name as pcp_name
from temp3 
left join physician as a on a.employeeid=temp3.physician
left join patient on patient.ssn=temp3.patient
left join nurse on nurse.employeeid = temp3.prepnurse
left join physician as b on b.employeeid=temp3.pcp;


-- 8.6 The Patient field in Undergoes is redundant, since we can obtain it from the Stay table. There are no constraints in force to prevent inconsistencies between these two tables. More specifically, the Undergoes table may include a row where the patient ID does not match the one we would obtain from the Stay table through the Undergoes.Stay foreign key. Select all rows from Undergoes that exhibit this inconsistency.
select undergoes.* from stay right join undergoes on stay.stayid=undergoes.stay where stay.patient<>undergoes.patient;
    
-- 8.7 Obtain the names of all the nurses who have ever been on call for room 123.
select name from nurse 
--根据护士编号找到护士姓名
where employeeid in (
    select nurse 
    from on_call 
    where (cast(blockfloor as varchar)||cast(blockcode as varchar)) =
    --根据找到的地址找到护士的编号
        (select (cast(blockfloor as varchar)||cast(blockcode as varchar)) 
        from room 
        where roomnumber=123)
        --先找到123所在地址
        );

-- 8.8 The hospital has several examination rooms where appointments take place. Obtain the number of appointments that have taken place in each examination room.
select examinationroom,count(8) from appointment group by examinationroom order by examinationroom;

-- 8.9 Obtain the names of all patients (also include, for each patient, the name of the patient's primary care physician), such that \emph{all} the following are true:
    -- The patient has been prescribed some medication by his/her primary care physician.
    -- The patient has undergone a procedure with a cost larger that $5,000
    -- The patient has had at least two appointment where the nurse who prepped the appointment was a registered nurse.
    -- The patient's primary care physician is not the head of any department.

--这个题涉及patient,physician,prescribes,procedures,appointment,nurse and department,undergoes共8个表

select patient.name as pat_name, b.name as pcp_name 
from patient 
inner join prescribes on patient.ssn=prescribes.patient and patient.pcp=prescribes.physician
--找到由其主治医生开药方的病人
inner join undergoes on undergoes.patient=patient.ssn 
inner join procedures on procedures.code=undergoes.procedures and procedures.cost>5000
--找到做过超过5000美元手术费的病人
inner join (select patient,count(*) 
            from appointment inner join nurse on appointment.prepnurse=nurse.employeeid and nurse.registered='t' 
            group by patient 
            having count(*)>=2) as a on patient.ssn=a.patient
--找到曾预约过至少两次而且护士是已注册护士的病人
inner join (select physician.* 
            from physician 
            where employeeid not in 
                (select head from department)) as b 
            on b.employeeid=patient.pcp;
--找到主治医生不是所在部门领导的病人
