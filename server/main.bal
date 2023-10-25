import ballerina/graphql;
import ballerina/sql;
import ballerinax/mysql;
// import ballerina/io;
import ballerinax/mysql.driver as _;
// import ballerina/io;

type HoD record {
    int HoDId;
    string hodName;
    string officeNum;    
};

type Supervisor record {
int SuperID;
string SuperPassword;
string SuperVName;
int empID;
int SupGrade;
};

type logcheck record {
int id;
string pass;
string tbname;
};



type assignSupervisor record {
int empId;
int superId;
};

type Employee record {
   int empId;
   string empName;
   //string score;
};

type KPI record  {|
 string KpiName;
 string Metric;
 int KpiScore;
 int Grade ;
 string ApprovalStatus;
 int empID ;
|};

type departmentObjectives record {
int objId;
string ObjDescription;
//string empId;
};

type empScores record {
int score;
int totalScore;
int grade;
};

type EMPLOYEE record {
int empID;
string empPassword;
string empName;
int score;
int totalScore;
int grade;
int Supervisor;
};

type tah record {
int objId;
};

type KPIInput record {
 string KpiName; 
 string Metric;
 int KpiScore;
 int empID;
};

type gradeKpi record {
   int Grade;  
   int empID;
};

type createKPI record{
string KpiName; 
string Metric;
int empID;
};

type GradeSup record{
   int empID;
   int SupGrade;
   int SuperID;
};



service /perf on new  graphql:Listener(8080) {
 
    private final mysql:Client db;
    function init() returns error? {
     self.db = check new ("localhost", "root", "Ninjakilla212", "performanceManagement", 3306);
    }
 

// function doesObjectiveExist(departmentObjectives) returns boolean {
//     sql:Connection conn = check database->obtain();
//     sql:PreparedStatement stmt = check conn->prepareStatement("SELECT objId FROM departmentObjectives WHERE objId = ?");
//     stmt->setInt(1, id);
//     stream<departmentObjectives, sql:Result> result = check stmt->executeQuery();
    
//     if (result.length() > 0) {
//         return true;
//     } else {
//         return false;
//     }
// }

   //THIS IS FOR THE HOD
    
     resource function get doesObjectiveExist(int objIdv) returns string|error  {
        // Execute simple query to fetch record with requested id.
         sql:ParameterizedQuery result = `SELECT * FROM departmentobjectives WHERE  objId = ${objIdv}`;
         stream<departmentObjectives, sql:Error?> resultStream =   self.db->query(result);
         int result1=0;

        //   foreach departmentObjectives item in resultStream{
        //     if(item.ObjDescription !=""){
        //         result1="description found!";
        //     }
        //  }
        check from departmentObjectives vr in resultStream
        where vr.objId == objIdv
        do {
            result1=1;
        };
           
           if(result1==1){
            return "description found!";
           }else{
             return "description not found!";
           }
         
    }   
         remote function createDepartmentObjectives(departmentObjectives objective) returns string|error? {
               sql:ExecutionResult result=check self.db->execute(`
                    INSERT INTO departmentobjectives
                     VALUES (${objective.objId}, ${objective.ObjDescription})`);

         //io:println(objective.objId);
         if result.affectedRowCount>0{
         return ("Succesfuly added objective");
       } else {
        return error("Failed to add objective");
       } 
            
  
}

  remote function deleteDepartmentObjectives(int objIdv) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
                    DELETE FROM departmentobjectives WHERE objId = ${objIdv}`);

         if result.affectedRowCount>0{
         return ("Succesfuly deleted objective");
       } else {
        return error("Failed to delete objective");
       }  
}
 
   remote function AssignSupervisor(assignSupervisor obj) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`UPDATE EMPLOYEE SET Supervisor =${obj.superId} WHERE empID = ${obj.empId}`);

         if result.affectedRowCount>0{
         return ("Succesfully assigned");
       } else {
        return error("Failed to assign");
       }  
}

  remote function AprroveKpi(int empId) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`UPDATE KPI SET ApprovalStatus ="YES" WHERE empID = ${empId}`);

         if result.affectedRowCount>0{
         return ("Succesfully approved");
       } else {
        return error("Failed to approved");
       }  
}

    resource function get checkEmpKpi(int empId) returns KPI|error {
       // Execute simple query to fetch record with requested id.
         sql:ParameterizedQuery result = `SELECT * FROM KPI WHERE  empID = ${empId}`;
         stream<KPI, sql:Error?> resultStream =   self.db->query(result);
         //int result1=0;
         check from KPI vr1 in resultStream
         do{
            return vr1;
         };
         return { KpiName: "", Metric: "",KpiScore:0,Grade: 0 ,ApprovalStatus: "",empID:0};
    }
  


     // THIS IS FOR THE Supervisor

       remote function DeleteEmployeeKPI(int empID1) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
                    DELETE FROM KPI WHERE empID = ${empID1}`);

         if result.affectedRowCount>0{
         return ("Succesfuly deleted KPI");
       } else {
        return error("Failed to delete KPI");
       }  
}

   remote function UpdateEmployeeKPIs(KPIInput updateKpi) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
      UPDATE KPI
      SET KpiName =${updateKpi.KpiName},  Metric =${updateKpi.Metric},  KpiScore =${updateKpi.KpiScore}
      WHERE empID =  ${updateKpi.empID}`);

         if result.affectedRowCount>0{
         return ("Succesfully  UPDATED!");
       } else {
        return error("Failed to UPDATE");
       }  
}

   remote function GradeemployeeKPIs(gradeKpi gkp) returns string|error? {
        sql:ExecutionResult result=check self.db->execute(`
      UPDATE KPI
      SET  Grade =${gkp.Grade}
      WHERE empID =  ${gkp.empID}`);

         if result.affectedRowCount>0{
         return ("Succesfully  Graded!");
       } else {
        return error("Failed to Grade!");
       } 
   }


     //THIS IS FOR THE Employee

     remote function CreateemployeeKPIs(createKPI crt) returns string|error? {
      sql:ExecutionResult result=check self.db->execute(`
                    INSERT INTO KPI(KpiName,Metric,empID)
                     VALUES (${crt.KpiName}, ${crt.Metric},${crt.empID})`);

         //io:println(objective.objId);
         if result.affectedRowCount>0{
         return ("Succesfuly added KPI");
       } else {
        return error("Failed to add KPI");
       } 
 }

    resource  function get checkClient(logcheck checks) returns string|error? {
       sql:ParameterizedQuery result=``;
      if(checks.tbname=="Employee"){
        result=`
           SELECT * FROM  EMPLOYEE WHERE empID=${checks.id} AND empPassword = ${checks.pass} `;
      stream<EMPLOYEE, sql:Error?> resultStream =   self.db->query(result);
      int result1=0;
   
        check from EMPLOYEE vr in resultStream
        where vr.empID == checks.id
        do {
            result1=1;
        };
           
           if(result1==1){
            return "1";
           }else{
             return "2";
           }
       }
   else if(checks.tbname=="SUPERVISIOR"){
     result=`
           SELECT * FROM  SUPERVISIOR WHERE SuperID=${checks.id} AND SuperPassword =${checks.pass} `;
                 stream<Supervisor, sql:Error?> resultStream =   self.db->query(result);
      int result1=0;
   
        check from Supervisor vr in resultStream
        where vr.SuperID == checks.id
        do {
            result1=1;
        };
           
           if(result1==1){
            return "1";
           }else{
             return "2";
           }
   }
   else{
        result=`
           SELECT * FROM  HOD WHERE HodID=${checks.id} AND HodPassword =${checks.pass}`;
            stream<HoD, sql:Error?> resultStream =   self.db->query(result);
      int result1=0;
   
        check from HoD vr in resultStream
        where vr.HoDId == checks.id
        do {
            result1=1;
        };
           
           if(result1==1){
            return "1";
           }else{
             return "2";
           }
   }

     
   
   }



   
} 



   