import Type "Types";
import Buffer "mo:base/Buffer";
import Result "mo:base/Result";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import HashMap "mo:base/HashMap";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Hash "mo:base/Hash";
import Principal "mo:base/Principal";
import Order "mo:base/Order";
import Text "mo:base/Text";

actor class StudentWall() {
  type Message = Type.Message;
  type Content = Type.Content;
  type Survey = Type.Survey;
  type Answer = Type.Answer;

    

    var messageId : Nat = 0;

    //below is for removing warning in Hash.hash
    type Hash = Hash.Hash;
    func  _hashNat (n : Nat) : Hash {
      Text.hash(Nat.toText(n));
    };
    // let wall = HashMap.HashMap<Nat, Message>(1, Nat.equal, Hash.hash); //throwing error in Hash.hash 
    let wall = HashMap.HashMap<Nat, Message>(1, Nat.equal, _hashNat);
    
    type Order = Order.Order;
    func compareMessage(m1: Message, m2: Message) : Order {
      if(m1.vote == m2.vote) {
        return #equal;
      };
      if(m1.vote > m2.vote) {
        return #less;
      };
      return #greater;
    };


  // Add a new message to the wall
  public shared ({ caller }) func writeMessage(c : Content) : async Nat {
    let message : Message = {
            vote = 0; 
            content = c; 
            creator = caller;
            };

        let id : Nat = messageId;
        messageId += 1;
        wall.put(id, message);
        return id;
  };

  // Get a specific message by ID
  public shared query func getMessage(messageId : Nat) : async Result.Result<Message, Text> {
        if(messageId > wall.size()) {
          #err("Message ID is not existing");
        } else {
          let message = wall.get(messageId);
          switch(message) {
            case(null) {
              #err("Message is Null");
            };
            case(?message) {
              let res = wall.get(messageId);
              #ok(message);
            };
          };
        };
      };
  

  // Update the content for a specific message by ID
  public shared ({ caller }) func updateMessage(messageId : Nat, c : Content) : async Result.Result<(), Text> {
    if(messageId > wall.size()) {
      #err("Message ID is not existing");
    }else {
      let message = wall.get(messageId);
      switch(message) {
        case(null){
        #err("Message is Null");
      };
        case(?message) {
          if(Principal.equal(message.creator, caller)) {
            let updatedMessage : Message = {
              vote = message.vote;
              content = c;
              creator = caller;
            };
            let res = wall.replace(messageId, updatedMessage);
            #ok();
          } else {
            #err("Not the owner of the message");
          };
        };
    };
    };
  };

  // Delete a specific message by ID 
  public shared ({ caller }) func deleteMessage(messageId : Nat) : async Result.Result<(), Text> {
    if(messageId > wall.size()) {
      #err("Message ID is not existing");
    }else {
      let message = wall.get(messageId);
      switch(message) {
        case(null){
        #err("Message is Null");
      };
        case(?message) {
          if(Principal.equal(message.creator, caller)) {
            
            let res = wall.remove(messageId);    // try to implement wall.delete
            #ok();
          } else {
            #err("Not the owner of the message");
          };
        };
    };
    };
  };

  // Voting
  public func upVote(messageId : Nat) : async Result.Result<(), Text> {
   if(messageId > wall.size()) {
          #err("Message ID is not existing");
        } else {
          let message = wall.get(messageId);
          switch(message) {
            case(null) {
              #err("Message is Null");
            };
            case(?message) {
              let updatedMessage : Message = {
              vote = message.vote + 1;
              content = message.content;
              creator = message.creator;
            };
              let res = wall.replace(messageId, updatedMessage);
              
              #ok();
            };
          };
        };
      };
  
  

  public func downVote(messageId : Nat) : async Result.Result<(), Text> {
    if(messageId > wall.size()) {
          #err("Message ID is not existing");
        } else {
          let message = wall.get(messageId);
          switch(message) {
            case(null) {
              #err("Message is Null");
            };
            case(?message) {
              let updatedMessage : Message = {
              vote = message.vote - 1;
              content = message.content;
              creator = message.creator;
            };
              let res = wall.replace(messageId, updatedMessage);
              
              #ok();
            };
          };
        };
      };


  // Get all messages
  public  query  func getAllMessages() : async [Message] {
    let bufA = Buffer.Buffer<Message>(0);
    for (msg in wall.vals()) {
      bufA.add(msg);
    };
    Buffer.toArray(bufA);

  };

  // Get all messages ordered by votes
  public query func getAllMessagesRanked() : async [Message] {
    let array : [Message] = Iter.toArray(wall.vals());
    Array.sort<Message>(array, compareMessage)

};
}