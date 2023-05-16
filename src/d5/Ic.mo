// module {
//   public type CanisterId = Principal;
//   public type CanisterSettings = {
//     controllers : [Principal];
//     compute_allocation : Nat;
//     memory_allocation : Nat;
//     freezing_threshold : Nat;
//   };

//   public type ManagementCanisterInterface = actor {
//     create_canister : ({ settings : ?CanisterSettings }) -> async ({
//       canister_id : CanisterId;
//     });
//     install_code : ({
//       mode : { #install; #reinstall; #upgrade };
//       canister_id : CanisterId;
//       wasm_module : Blob;
//       arg : Blob;
//     }) -> async ();
//     update_settings : ({
//       canister_id : CanisterId;
//       settings : CanisterSettings;
//     }) -> async ();
//     deposit_cycles : ({ canister_id : Principal }) -> async ();
//     canister_status : ({ canister_id : CanisterId }) -> async ({
//       status : { #running; #stopping; #stopped };
//       settings : CanisterSettings;
//       module_hash : ?Blob;
//       memory_size : Nat;
//       cycles : Nat;
//       idle_cycles_burned_per_day : Nat;
//     });
//   };
// };

import Result "mo:base/Result";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Error "mo:base/Error";

module {
    private let IC = actor "aaaaa-aa" : actor { canister_status : { canister_id : Principal } -> async { controllers : [Principal] }; };

    private func parseControllersFromCanisterStatusErrorIfCallerNotController(errorMessage : Text) : [Principal] {
        let lines = Iter.toArray(Text.split(errorMessage, #text("\n")));
        let words = Iter.toArray(Text.split(lines[1], #text(" ")));
        var i = 2;
        let controllers = Buffer.Buffer<Principal>(0);
        while (i < words.size()) {
            controllers.add(Principal.fromText(words[i]));
            i += 1;
        };
        Buffer.toArray<Principal>(controllers);
    };

    public func getCanisterControllers(canisterId : Principal) : async [Principal] {
        try {
            let status = await IC.canister_status({ canister_id = canisterId; });
            return status.controllers;
        } catch(e) {
            return parseControllersFromCanisterStatusErrorIfCallerNotController(Error.message(e));
        };
    };
};