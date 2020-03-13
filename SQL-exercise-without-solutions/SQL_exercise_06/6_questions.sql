-- Scientists
-- 6.1 List all the scientists' names, their projects' names, 
    -- and the hours worked by that scientist on each project, 
    -- in alphabetical order of project name, then scientist name.
select sci_name,name as pro_name,hours 
from (select ssn,name as sci_name from scientists) as a right join assignedto on a.ssn=assignedto.scientist left join projects on projects.code=assignedto.project
order by pro_name,sci_name;
-- 6.2 Select the project names which are not assigned yet
select name from projects where code not in (select distinct project from assignedto);