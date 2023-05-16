// import HashMap "mo:base/HashMap";
// import Nat "mo:base/Nat";
// import Hash "mo:base/Hash";
// import Result "mo:base/Result";
// import Option "mo:base/Option";

// actor studentWall{

//    public type Content = {
//     #Text: Text;
//     #Image: Blob;
//     #Video: Blob;
//     };

//     type Message = {    
//         vote : Int;
//         content : Content;
//         creator : Principal;  //for testing only, to be replaced with Principal
//     };

//     var messageId : Nat = 0;

//     let wall = HashMap.HashMap<Nat, Message>(1, Nat.equal, Hash.hash);

//     // Add a new message to the wall
//     public shared ({caller}) func writeMessage(c : Content) : async Nat {
//         let message : Message = {
//             vote = 0; 
//             content = c; 
//             creator = caller;
//             };

//         let id : Nat = messageId;
//         messageId += 1;
//         wall.put(id, message);
//         return id;
//     };

//     //Get a specific message by ID
//     public shared query func getMessage(messageId : Nat) : async Result.Result<Message, Text> {
//         let id = wall.size();
//         let y = wall.get(messageId);
//         // let z = Option.get(y, 0);
//         // func toMessage () : async Message {
//         //     switch (y){
//         //         case(null) {return(y);};
//         //         case(? something) {return (something);};
//         //     };
//         // };
//         for(message in wall.vals()) {
            
//                 let x = {vote=message.vote; content=message.content; creator=message.creator};
//                 if(messageId == id) {
//                     wall.put(id, x);
//                 };
//                 return x;
//         };
        
//         if(messageId < id) { #ok(x)} else {#err("Message inexisting!!!")};
//     };

//     // Update the content for a specific message by ID
//     // public shared({caller}) func updateMessage(messageId : Nat, c : Content) : async Result.Result<(), Text> {
//     //     let id = wall.size();
//     //     let y = wall.get(messageId);
//     //     let creator = 

//     //     // if((creator == caller) or (messageId < id))  { #ok(wall.put(messageId, c))} else {#err("Not Authorized to update message!")};
//     //     if((creator == caller) or (messageId < id))  { #ok(wall.put(messageId, c))} else {#err("Not Authorized to update message!")};

//     // };

//     // //Delete a specific message by ID
//     // deleteMessage: shared (messageId : Nat) -> async Result.Result<(), Text>;

//     // // Voting
//     // upVote: shared (messageId  : Nat) -> async Result.Result<(), Text>;
//     // downVote: shared (messageId  : Nat) -> async Result.Result<(), Text>;

//     // //Get all messages
//     // getAllMessages : query () -> async [Message];

//     // //Get all messages
//     // getAllMessagesRanked : query () -> async [Message];
// };