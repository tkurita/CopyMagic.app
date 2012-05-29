property MagicOperation : module
property FinderSelection : module
property XFile : module

on module loaded loader
	MagicOperation's set_delegate(me)
end module loaded

property loader : boot (module loader) for me
property _useAliasName : true
property _bundleExtensions : {}

(* = delegate of MagicOperation *)
on should_process_for(x_folder)
	set a_suffix to x_folder's path_extension()
	return a_suffix is not in _bundleExtensions
end should_process_for

on process_original for x_item from x_alias at x_folder
	set x_destination to x_folder
	if _useAliasName then
		set alias_name to x_alias's item_name()
		set an_info to x_item's info()
		if alias_name is not in {an_info's displayed name, an_info's name} then
			set x_destination to x_folder's child(alias_name)
		end if
	end if
	return x_item's copy_with_opts(x_destination, {with_replacing:false})
end process_original

(* = accessors *)
on use_alias_name()
	set _useAliasName to true
end use_alias_name

on set_bundle_extensions(extensionList)
	set _bundleExtensions to extensionList
end set_bundle_extensions

on add_bundle_extension(a_suffix)
	if a_suffix is not in _bundleExtensions then
		set end of _bundleExtensions to a_suffix
	end if
end add_bundle_extension

on broken_alias_files()
	return MagicOperation's broken_alias_files()
end broken_alias_files

(* = others *)

on initialize()
	set _bundleExtensions to {}
	set _useAliasName to true
end initialize

on run
	try
		--boot (module loader) for me
		main()
	on error msg number errno
		if errno is not -128 then
			display alert msg message "Error Number : " & errno
		end if
	end try
end run

on main()
	add_bundle_extension("framework")
	MagicOperation's process_finder_selection()
	beep
	return (MagicOperation's broken_alias_files()'s count_items() is 0)
end main

on open a_list
	MagicOperation's initialize()
	add_bundle_extension("framework")
	repeat with an_item in a_list
		set x_item to XFile's make_with(an_item)
		if x_item's is_folder() then
			MagicOperation's process_for_folder(x_item)
		end if
	end repeat
	beep
	return (MagicOperation's broken_alias_files()'s count_items() is 0)
end open

on process_for_folder(x_folder)
	MagicOperation's initialize()
	MagicOperation's process_for_folder(x_folder)
	return (MagicOperation's broken_alias_files()'s count_items() is 0)
end process_for_folder

