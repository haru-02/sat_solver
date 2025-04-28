module Formula = struct
  include List
  
  type variable = string
  type literal = variable * bool
  type clause = literal list
  type cnf = clause list
  type assignment = (variable * bool)
  type model = assignment list

  let rec find_assignment var model =
    match model with
      | [] -> None
      | (v, b) :: rest -> if v = var then Some b 
        else find_assignment var rest

  let is_clause_satisfied cl model =
    List.fold_left (fun acc lit -> let (v, b) = lit in
      acc || (Some b = find_assignment v model))
      false cl

  let is_cnf_satisfied (cnf:cnf) (ml:model) : bool =
    List.fold_left (fun acc cl -> acc && is_clause_satisfied cl ml) true cnf
  
  let variables_in_cnf (cnf:cnf) : variable list =
    let contains (var:variable) (vars:variable list) : bool =
    List.fold_left (fun acc nxt -> acc || nxt = var) false vars in
  List.fold_left (fun all_variables nxt ->
                      List.fold_left (fun acc nxt ->
    let (var, _) = nxt in if not (contains var acc) then var::acc else acc)
     all_variables nxt)
    [] cnf

  (* method to print model *)
  let print_model (ml:model) =
    List.fold_left
      (fun _ (sym, b) ->
        print_string sym;
        print_string " = ";
        if b then print_string "true" else print_string "false";
        print_newline ()) () ml
  
  (* method to print cnf *)
  let print_cnf (cnf:cnf) =
    List.fold_left
      (fun _ clause ->
        print_string "---CLAUSE---";
        print_newline ();
        print_model clause) () cnf
end