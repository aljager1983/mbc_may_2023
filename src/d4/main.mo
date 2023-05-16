import TrieMap "mo:base/TrieMap";
import Trie "mo:base/Trie";
import Result "mo:base/Result";
import Text "mo:base/Text";
import Option "mo:base/Option";
import Debug "mo:base/Debug";
import Buffer "mo:base/Buffer";
import Principal "mo:base/Principal";

import Account "Account";
// NOTE: only use for local dev,
// when deploying to IC, import from "rww3b-zqaaa-aaaam-abioa-cai"
import BootcampLocalActor "BootcampLocalActor";





actor class MotoCoin() {
  public type Account = Account.Account;

  var ledger : TrieMap.TrieMap<Account, Nat> = TrieMap.TrieMap<Account, Nat>(Account.accountsEqual, Account.accountsHash);
  var supply : Nat = 1000000;
  var airdropSupply : Nat = 1000;
  // Returns the name of the token
  public shared query func name() : async Text {
    return "MotoCoin";
  };

  // Returns the symbol of the token
  public shared query func symbol() : async Text {
    return "MOC";
  };

  // Returns the the total number of tokens on all accounts
  public shared func totalSupply() : async Nat {
    return supply;
  };

  // Returns the default transfer fee
   public func balanceOf(account : Account): async Nat{ 
        let bal : ?Nat = ledger.get(account);
        switch bal{
            case (null) return 0;
            case (?bal)  return bal;
        };
    };

  // Transfer tokens to another account
   public func transfer(from : Account, to : Account, qty : Nat) : async Result.Result<(),Text>{
        let balFrom = await balanceOf(from);
        if (balFrom < qty) return #err("Not Enough tokens");
        let balTo = await balanceOf(to);
        ledger.put(from, balFrom - qty);
        ledger.put(to, balTo + qty);
        return #ok ();
    };

 

  //from template--getAllStudentsPrincipal
  // On the IC, you should import actor from "rww3b-zqaaa-aaaam-abioa-cai" and call same method
 


  // code form somone
  // Airdrop 1000 MotoCoin to any student that is part of the Bootcamp.
  public func airdrop() : async Result.Result<(), Text> {
    let studentsList = actor ("rww3b-zqaaa-aaaam-abioa-cai") : actor {
      getAllStudentsPrincipal : shared () -> async [Principal];
    };
    let listStudents = await studentsList.getAllStudentsPrincipal();
    for(p in listStudents.vals()) {
      let acc : Account = {
        owner : Principal = p;
        subaccount : ?Account.Subaccount = null;
      };
      
      ledger.put(
        acc, 
        airdropSupply
      );
      
    };
    return #err("Error");
  };


  
};
