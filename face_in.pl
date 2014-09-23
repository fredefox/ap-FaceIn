/*
* This is an implementation of the "FaceIn"-library.
*
* The implementation follows the specification located at:
*
*     [advanced programming course
*     homepage](http://www.diku.dk/~kflarsen/ap-e2014/facein/facein.html)
*
* Written by Frederik Hanghøj Iversen
* for the course Advanced Programming
* at The University of Copenhagen 2014
*
* me@fredefox.eu /^._
*  ,___,--~~~~--' /'~
*  `~--~\ )___,)/'
*      (/\\_  (/\\_
*/

/*
* Utility-functions.
*/
member_(A, [A|_]).
member_(A, [_|AS]) :- member_(A, AS).

is_list_([]).
is_list_([_|AS]) :- is_list_(AS).

/*
* This is actually not like `select/3` at all.
*
* For instance this is not satisfiable:
*
*   select(_, graph([person(_,_)]), _).
*
* So, why have I called it `select_`, because I would like to understand why I
* can't use select like I tried above, maybe I could do it more intellegently.
* Like make `person`s "selectable". I know that `person` is really just a
* predicate. Anyways. `select_` is only intended to work with this library.
*/
select_(Name, graph([Res|_]), Res) :- Res = person(Name, _).
select_(Name, graph([_|Persons]), Res) :- select_(Name, graph(Persons), Res).
/*
* Basic definitions.
*/

/*
* Given:
*
*   my_atom(atom(_)).
*
* This is false:
*
*   my_atom(a).
*/
% TODO: `atom` might be disallowed.
person(Name, List) :-
	atom(Name),
	is_list_(List).

graph([]).
graph([person(_, _)|Persons]) :-
	graph(Persons).

/*
* Library-functions
*/

/*
* `goodfriends` should take a network as an argument as per specification. It
* is therefore my thinking that the first two parameters should be the *names*
* of the people being compared. I will define an ancillary predicate that
* actually takes two `person`s as arguments.
*/
goodfriends_(person(A, AS), person(B, BS)) :-
	member_(A, BS),
	member_(B, AS).
goodfriends(A_name, B_name, Graph) :-
	select_(A_name, Graph, A),
	select_(B_name, Graph, B),
	goodfriends_(A,B).
