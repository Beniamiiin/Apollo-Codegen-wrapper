# Ruby wrapper over [apollo-codegen](https://github.com/apollographql/apollo-codegen)

## Reason

The problem of original [apollo-codegen](https://github.com/apollographql/apollo-codegen) tool is that it generates all requests and all fragments `*.graphql` files in one `API.swift` file. It's not a good idea because it's not comfortable and in one day Xcode can't open this file or you will face delays during scrolling.

## Available arguments

1. Apollo framework path. You can get it like this: `APOLLO_FRAMEWORK_PATH="$(eval find $FRAMEWORK_SEARCH_PATHS -name "Apollo.framework" -maxdepth 1)"`
2. GraphQL directory path
3. Xcodeproj path. This argument is optional, if don't pass will be found `*.xcodeproj` file in root directory

## GraphQL directory hierarchy

```
GraphQL
	Generated
		Types.swift
		Fragments
			...
		Requests
			...
	Sources
		Fragments
			...
		Requests
			...
	schema.json
```

`GraphQL/Sources/Fragments` - this folder should contain `*.graphql` files with fragments
`GraphQL/Sources/Requests` - this folder should contain `*.graphql` files with requests

`GraphQL/Generated/Fragments` - this folder contain generated `*.swift` files with fragments
`GraphQL/Generated/Requests` - this folder contain generated `*.swift` files with requests

`Types.swift` - this file contain all enums generated according a schema file

> `apollo-codegen` generates `Types` file if some of enums used in `requests` or `fragments` files.

`schema.json` - a GraphQL schema file

## Adding a script to project

1. Create directory `Script` in root folder of your project.
2. Put `apollo-codegen.rb` into directory created at previous step.

## Adding a code generation build step

In order to invoke apollo-codegen as part of the Xcode build process, create a build step that runs before “Compile Sources”.

On your application targets’ “Build Phases” settings tab, click the “+” icon and choose “New Run Script Phase”. Create a Run Script, change its name to “Generate Apollo GraphQL API” and drag it just above “Compile Sources”. Then add the following contents to the script area below the shell:
for iOS Project

```
APOLLO_FRAMEWORK_PATH="$(eval find $FRAMEWORK_SEARCH_PATHS -name "Apollo.framework" -maxdepth 1)"

if [ -z "$APOLLO_FRAMEWORK_PATH" ]; then
echo "error: Couldn't find Apollo.framework in FRAMEWORK_SEARCH_PATHS; make sure to add the framework to your project."
exit 1
fi

Scripts/apollo-codegen.rb $APOLLO_FRAMEWORK_PATH $PROJECT_NAME/GraphQL
```

The script above will invoke apollo-codegen through the check-and-run-apollo-codegen.sh wrapper script, which is actually contained in the Apollo.framework bundle. The main reason for this is to check whether the version of apollo-codegen installed on your system is compatible with the framework version installed in your project, and to warn you if it isn’t. Without this check, you could end up generating code that is incompatible with the runtime code contained in the framework.

## More information about Apollo
1. An original tool [apollo-codegen](https://github.com/apollographql/apollo-codegen)
2. Apollo iOS [docs](https://www.apollographql.com/docs/ios/)

License

The script is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).