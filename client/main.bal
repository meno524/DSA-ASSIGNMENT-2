import ballerina/graphql;
import ballerina/io;

type departmentObjectives record {
int objId;
string description;
//string empId;
};

type ProductResponse record {|
    record {|anydata dt;|} data;
|};

public function main() returns error? {
    io:println("****** Performance Management System ********");

    while (true) {
        string option = io:readln("Enter 1 to login as HOD: \n"+
                                     "Enter 2 to login as Supervisor: \n"+
                                     "Enter 3 to login as Employee: \n");

        match option {
            //Login HOD
            "1" => {
                map<json> intResultLogin =   check checkClient1("HOD");
                io:println(intResultLogin.data.checkClient);
                match intResultLogin.data.checkClient {
                    //Succesful login 
                    "1" => { // HOD
                        string HOD = "";

                       while (HOD != "0") {
                        io:println("*****Welcome To FCI! Choose what to do*******\n" +
                                                    "Enter 1 to check objective HOD\n" +
                                                    "Enter 2 to create objective HOD\n" +
                                                    "Enter 3 to delete objective HOD\n" +
                                                    "Enter 4 Assign the Employee to a supervisor HOD\n" +
                                                    "Enter 0 to exit");

                            HOD = io:readln("Enter choice here: ");

                            
                                 match HOD {
                                 "1" => {io:println(check doesObjectiveExist1());}
                                 "2" => {io:println(createDepartmentObjectives1());}
                                 "3" => {io:println(deleteDepartmentObjectives1());}
                                 "4" => {io:println(AssignSupervisor1());}
                                
                                
                                //Log out of HOD 
                                "0" => {
                                    io:println("Goodbye, exiting the librarian menu.");
                                    break; // Exit the librarian menu
                                }
                                
                                //Handle Invalid Choice
                                _ => {
                                    io:println("Invalid choice. Please try again.");
                                }
                            }
                        }
                    }
                    //UnSuccesful login 
                    "2" => { 
                          io:println("Wrong Credentials Entered");
                    }
                }
            }
            //Login Supervisor
              "2" => {
                map<json> intResultLogin  =  check checkClient1("SUPERVISIOR");
                match intResultLogin.data.checkClient {
                    //Succesful login 
                    "1" => { // Supervisor
                        string Supervisor = "";

                       while (Supervisor != "0") {
                        io:println("*****Welcome To FCI! Choose what to do*******\n" +
                                                     "Enter 1 check Employee's KPIs Supervisor\n" +
                                                     "Enter 2 Approve Employee's KPIs Supervisor\n" +
                                                     "Enter 3 delete Employee's KPIs Supervisor\n" +
                                                     "Enter 4 update Employee's KPIs Supervisor\n" +
                                                     "Enter 5 grade Employee's KPIs Supervisor\n" +
                                                     "Enter 0 to exit");

                            Supervisor = io:readln("Enter choice here: ");

                            
                                 match Supervisor {
                                 "1" => { io:println(checkEmpKpi1());}
                                 "2" => { io:println(AprroveKpi1());}
                                 "3" => { io:println(DeleteEmployeeKPI1());}
                                 "4" => { io:println(UpdateEmployeeKPIs1());}
                                 "5" => { io:println(GradeemployeeKPIs1());}
                                
                                
                                //Log out of Supervisor
                                "0" => {
                                    io:println("Goodbye, exiting the librarian menu.");
                                    break; // Exit the librarian menu
                                }
                                
                                //Handle Invalid Choice
                                _ => {
                                    io:println("Invalid choice. Please try again.");
                                }
                            }
                        }
                    }
                    //UnSuccesful login 
                    "2" => { 
                          io:println("Wrong Credentials Entered");
                    }
                }
            }
         //Employee
           "3" => {
                map<json> intResultLogin =  check checkClient1("Employee");
                match intResultLogin.data.checkClient {
                    //Succesful login 
                    "1" => { // Employee
                        string Employee = "";

                       while (Employee != "0") {
                        io:println("*****Welcome To FCI! Choose what to do*******\n" +
                                                     "Enter 1 create KPI Employee\n" +
                                                     "Enter 2 grade supervisior Employee\n" +
                                                     "Enter 0 to exit");

                            Employee = io:readln("Enter choice here: ");

                            
                                 match Employee {
                                 "1" => { io:println( CreateemployeeKPIs1());}
                                 "2" => {io:println( GradeSupervisor1());}                                
                                
                                //Log out of Supervisor
                                "0" => {
                                    io:println("Goodbye, exiting the librarian menu.");
                                    break; // Exit the librarian menu
                                }
                                
                                //Handle Invalid Choice
                                _ => {
                                    io:println("Invalid choice. Please try again.");
                                }
                            }
                        }
                    }
                    //UnSuccesful login 
                    "2" => { 
                          io:println("Wrong Credentials Entered");
                    }
                }
            }

            "0" => {
                       io:println("Goodbye, exiting main menu.");
                       break; // Exit the student menu
                                }
            _ => {
                io:println("Invalid choice. Please try again.");
            }
        }
        
    }   
}



type Responses record {
    record { anydata dt; } data;
};


type tah record {
int objIdv;
};

function doesObjectiveExist1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int objId1 = check int:fromString(io:readln("Enter the objId"));  

    string doc = string `query doesObjectiveExist($gf: Int!) {
        doesObjectiveExist(objIdv:$gf)
    }`;

      map<json> variables = {"gf": objId1};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}

function createDepartmentObjectives1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int objId1 = check int:fromString(io:readln("Enter the objId"));  
    string ObjDescription = io:readln("Enter the objective discription");

    string doc = string `mutation createDepartmentObjectives($obID: Int!,$obDes:String!) {
       createDepartmentObjectives(objective:{objId:$obID,ObjDescription:$obDes})
    }`;

     map<json> variables = {"obID":objId1,"obDes":ObjDescription};

    map<json>  ObjResponse = check cli->execute(doc,variables);


    return ObjResponse;

}


function deleteDepartmentObjectives1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int objId1 = check int:fromString(io:readln("Enter the objId of the description to delete"));  

    string doc = string `mutation deleteDepartmentObjectives($gf: Int!) {
        deleteDepartmentObjectives(objIdv:$gf)
    }`;

      map<json> variables = {"gf": objId1};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}

function AssignSupervisor1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empid = check int:fromString(io:readln("Enter the employee id you want to assign a supervisor to")); 

    int superid = check int:fromString(io:readln("Enter the Supervisor id you want to assign to the employee"));  
 

     string doc = string `mutation AssignSupervisor($empID: Int!,$supId:Int!) {
       AssignSupervisor(obj:{empId:$empID,superId:$supId})
    }`;

      map<json> variables = {"empID": empid,"supId": superid};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}


function AprroveKpi1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empid = check int:fromString(io:readln("Enter the employee id you want to assign a supervisor to"));  

    string doc = string `mutation AprroveKpi($empID: Int!) {
       AprroveKpi(empId:$empID)
    }`;

    map<json> variables = {"empID":empid};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}


function checkEmpKpi1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empID = check int:fromString(io:readln("Enter the ID of the employee to see thier KPI"));  

    string doc = string `query checkEmpKpi($gf: Int!) {
    checkEmpKpi(empId:$gf) {
        KpiName
        Metric
        KpiScore
        Grade
        ApprovalStatus
        empID
    }
    }`;

      map<json> variables = {"gf": empID};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;
}

function DeleteEmployeeKPI1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empId1 = check int:fromString(io:readln("Enter the empId of the KPI to delete"));  

    string doc = string `mutation DeleteEmployeeKPI($gf: Int!) {
        DeleteEmployeeKPI(empID1:$gf)
    }`;

      map<json> variables = {"gf":empId1};

    map<json>  ObjResponse = check cli->execute(doc, variables);


    return ObjResponse;

}
    
 function UpdateEmployeeKPIs1() returns map<json> | error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empId1 = check int:fromString(io:readln("Enter the empId of the KPI to update"));  
    string KpiName = io:readln("Enter KpiName to update");
    string Metric = io:readln("Enter Metric to update");
    int KpiScore1 = check int:fromString(io:readln("Enter KpiScore to update"));     
    
    string doc = string `mutation UpdateEmployeeKPIs($gf: Int!, $kpName: String!, $metric: String!, $kapSc: Int!) {
        UpdateEmployeeKPIs(updateKpi: { empID: $gf, KpiName: $kpName, Metric: $metric, KpiScore: $kapSc })
    }`;

    map<json> variables = {"gf": empId1, "kpName": KpiName, "metric": Metric, "kapSc": KpiScore1};

    map<json> ObjResponse = check cli->execute(doc, variables);

    return ObjResponse;
}

   function GradeemployeeKPIs1() returns map<json> | error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int empId1 = check int:fromString(io:readln("Enter the empId of the KPI to grade"));  
    int grade1 = check int:fromString(io:readln("Enter grade"));     
    
    string doc = string `mutation GradeemployeeKPIs($gf: Int!,$gradek: Int!) {
        GradeemployeeKPIs(gkp: { empID: $gf, Grade: $gradek })
    }`;

    map<json> variables = {"gf": empId1,  "gradek": grade1};

    map<json> ObjResponse = check cli->execute(doc, variables);

    return ObjResponse;
}
    function CreateemployeeKPIs1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    string KpiName = io:readln("Enter the KPI Name");
    string Metric = io:readln("Enter the Metric");
    int empId1 = check int:fromString(io:readln("Enter your empID"));   
   

    string doc = string `mutation CreateemployeeKPIs($kpiName: String!,$metric:String!,$gf: Int!) {
       CreateemployeeKPIs(crt:{KpiName:$kpiName,Metric:$metric,empID:$gf})
    }`;

     map<json> variables = {"kpiName":KpiName ,"metric":Metric,"gf":empId1};

    map<json>  ObjResponse = check cli->execute(doc,variables);


    return ObjResponse;

} 
     function GradeSupervisor1() returns  map<json> |error? {
    graphql:Client cli = check new("http://localhost:8080/perf");

    
    int empId1 = check int:fromString(io:readln("Enter your empID"));  
    int SupGrade1 = check int:fromString(io:readln("Enter the grade from 1 to 5 ")); 
    int SuperID1 = check int:fromString(io:readln("Enter supervisor ID"));  
   

    string doc = string `mutation GradeSupervisor($gf: Int!,$SupGrade1: Int!,$Super1: Int!) {
       GradeSupervisor(scr:{empID: $gf,SupGrade:$SupGrade1,SuperID:$Super1})
    }`;

     map<json> variables = {"gf":empId1 ,"SupGrade1":SupGrade1,"Super1":SuperID1};

    map<json>  ObjResponse = check cli->execute(doc,variables);


    return ObjResponse;

}


function checkClient1(string tbName) returns map<json>|error {
    graphql:Client cli = check new("http://localhost:8080/perf");

    int id = check int:fromString(io:readln("Enter the your ID"));  
    string pass = io:readln("Enter the your Password");  
    string tbName1 =tbName;

    string doc = string `query checkClient($gf: Int!, $ps: String!, $tbn: String!) {
        checkClient(checks:{id:$gf,pass:$ps ,tbname:$tbn})
    }`;

    map<json> variables = {"gf":id ,"ps":pass,"tbn":tbName1};
    map<json>  ObjResponse =  check cli->execute(doc, variables);

    return ObjResponse;

}

