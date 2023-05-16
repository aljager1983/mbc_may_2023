import Text "mo:base/Text";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Result "mo:base/Result";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Bool "mo:base/Bool";
import Iter "mo:base/Iter";

actor homeworkDiary{

    type Homework = {
        title : Text;
        description : Text;
        dueDate : Time.Time;
        completed : Bool;
    };

    let homeworkDiary = Buffer.Buffer<Homework>(0);
    var id : Nat = 0;

    // Add a new homework task
    public shared func addHomework (homework : Homework) : async Nat {
         homeworkDiary.add(homework);
        let y = Buffer.toArray<Homework>(homeworkDiary);
        id := y.size() - 1;
        return id;
    };

    // Get a specific homework task by id
    public shared query func getHomework (id : Nat) : async Result.Result<Homework, Text> {
        let x = homeworkDiary.size();
        if( id < x) { #ok (homeworkDiary.get(id))} else { #err("null")} 
    };

    // Update a homework task's title, description, and/or due date
    public shared func updateHomework (id : Nat, homework : Homework) : async Result.Result<(), Text> {
      
        let x = homeworkDiary.size();
        if( id < x) { #ok (homeworkDiary.put(id, homework))} else { #err("null")}
        
    };

    // Mark a homework task as completed 
    public shared func markAsCompleted (id : Nat) : async Result.Result<(), Text> {
      
        let x = homeworkDiary.size();
        
        let y : Homework = homeworkDiary.get(id);
        let z : Homework = {title=y.title; description=y.description; dueDate=y.dueDate; completed = true};
        if( id < x) { #ok (homeworkDiary.put(id, z))} else { #err("null")};
        };

    // Delete a homework task by id -- need to finalize delete function
    public shared func deleteHomework (id : Nat) : async Result.Result<(), Text> {
      
        let x = homeworkDiary.size();
        
        let y = homeworkDiary.get(id);
        let z = homeworkDiary.remove(id);
        let a = Buffer.toArray(homeworkDiary);
        if( id < x) { #ok (homeworkDiary.put(id, z))} else { #err("null")};
        };

      // Get the list of all homework tasks
      public shared query func getAllHomework () : async [Homework] {
        
        Buffer.toArray(homeworkDiary);
      };

      // Get the list of pending (not completed) homework tasks
      public shared query func getPendingHomework () : async [Homework] {
        
        let newBuf = Buffer.Buffer<Homework>(0);
        // let x = homeworkDiary.size();
        let y = homeworkDiary.vals();
        for(elements in y) {
            let z = {completed=elements.completed; title=elements.title; description=elements.description; dueDate=elements.dueDate};
            let x = {completed=false; title=elements.title; description=elements.description; dueDate=elements.dueDate};
           if(z == x) {
            newBuf.add(z);
            }
            
        };
        Buffer.toArray(newBuf);
        
      };
        
        
        

    //   Search for homework tasks based on a search terms
      public shared query func searchHomework(searchTerm : Text) : async [Homework] {
       let newBuf = Buffer.Buffer<Homework>(0);
        // let x = homeworkDiary.size();
        let y = homeworkDiary.vals();
        for(elements in y) {
            let z = {completed=elements.completed; title=elements.title; description=elements.description; dueDate=elements.dueDate};
            
           if(Text.contains(elements.title, #text searchTerm) or Text.contains(elements.description, #text searchTerm )) {
            newBuf.add(z);
            }
        };
        Buffer.toArray(newBuf);
        
      };
      
};

   

// to refactor the code if possible, and if theres solution for trap error in removing