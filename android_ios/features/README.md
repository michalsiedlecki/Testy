Adding test suite to mobile repo
----------------------------------
Use git submodule to add this whole test suite repo into the mobile repo:

```
$: cd mobile-ios
$: git submodule add https://github.com/leeoinc/mobile-calabash-testing features

This will add the test suite repo into the mobile repo in the folder `features/`.
```

Running test suite
--------------------
Always use the `features/config/run_calabash.rb` to start cucumber to run the test suite in the **root** folder of the mobile repo. Do not use `cucumber` by itself because that will load the `features/config/run_calabash.rb` script and run it in an infinite loop.

Example:

```
$: cd mobile-ios
$: features/config/run_calabash.rb ios --tags @done,@review
```

`run_calabash.rb`, when it runs, will create symbolic links to the the files in `features/config` in the root folder of the mobile repo. A profile must be passed to it. The default profiles that we have right now are:

```
android
ios
iosUS
```

`run_calabash.rb` will also pass all the remaining options to the profile as well. So the format should be this when you run `run_calabash.rb`:

```
$: features/config/run_calabash.rb [profile] [cucumber options]
```

Example:

```
$: features/config/run_calabash.rb ios -r features/lib --tags @lib

This will load up the ios profile and then also pass "-r features/lib --tags @lib" to cucumber
```
