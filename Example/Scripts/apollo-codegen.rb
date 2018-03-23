#!/usr/bin/env ruby

require 'xcodeproj'

# Constants

APOLLO_CODEGEN_SCRIPT = `echo "$CONFIGURATION"`.tr("\n", '').empty? ? "apollo-codegen" : "#{ARGV[0]}/check-and-run-apollo-codegen.sh"
GRAPHQL_DIRECTORY_PATH = ARGV[1]
XCODEPROJ_PATH = ARGV[2] != nil ? ARGV[2] : Dir["*.xcodeproj"].first

SOURCE_FILES_PATH = "#{GRAPHQL_DIRECTORY_PATH}/Sources"
FRAGMENTS_DIRECTORY_PATH = "#{SOURCE_FILES_PATH}/Fragments"
REQUESTS_DIRECTORY_PATH = "#{SOURCE_FILES_PATH}/Requests"

SCHEME_FILE_PATH = "#{GRAPHQL_DIRECTORY_PATH}/schema.json"

GENERATED_FILES_PATH = "#{GRAPHQL_DIRECTORY_PATH}/Generated"
GENERATED_FRAGMENTS_DIRECTORY_PATH = "#{GENERATED_FILES_PATH}/Fragments"
GENERATED_REQUESTS_DIRECTORY_PATH = "#{GENERATED_FILES_PATH}/Requests"

# Methods

def need_update_xcode_project
	generated_fragments_files_paths = Dir["#{Dir.pwd}/#{GENERATED_FRAGMENTS_DIRECTORY_PATH}/*.swift"]
	generated_fragments_files_names = generated_fragments_files_paths.map { |generated_file| File.basename(generated_file) }
	fragments_files_paths = Dir["#{FRAGMENTS_DIRECTORY_PATH}/*.graphql"]

	return true if generated_fragments_files_paths.count != fragments_files_paths.count

	fragments_files_paths.each do |request_file|
		return true unless generated_fragments_files_names.include?(request_file)
	end

	generated_requests_files_paths = Dir["#{Dir.pwd}/#{GENERATED_REQUESTS_DIRECTORY_PATH}/*.swift"]
	generated_requests_files_names = generated_requests_files_paths.map { |generated_file| File.basename(generated_file) }
	requests_files_paths = Dir["#{REQUESTS_DIRECTORY_PATH}/*.graphql"]

	return true if generated_requests_files_paths.count != requests_files_paths.count

	requests_files_paths.each do |request_file|
		return true unless generated_requests_files_names.include?(request_file)
	end

	return false
end

def remove_all_files_from(xcodeproj, dir)
	dir.each do |file_path|
		xcodeproj.targets.first.build_phases.each do |build_phase|
			if build_phase.isa == 'PBXSourcesBuildPhase'
				build_phase.files.each do |build_file|
					next unless build_file.file_ref
					
					build_file_path = build_file.file_ref.hierarchy_path.to_s
					build_file_full_path = "#{Dir.pwd}#{build_file.file_ref.hierarchy_path.to_s}"
					
			      	if build_file_full_path == file_path
			        	build_phase.remove_build_file(build_file)
			      	end
			    end
			end
		end

		reference = xcodeproj.reference_for_path(file_path)
		reference.remove_from_project if reference
		File.delete(file_path)
	end
end

def generate_fragments(xcodeproj, update_xcode_project)
	Dir["#{FRAGMENTS_DIRECTORY_PATH}/*.graphql"].each do |file_path|
		fragments_files_paths = Dir["#{FRAGMENTS_DIRECTORY_PATH}/*.graphql"].each.select { |path| path != file_path }.map { |path| path }.join(" ")
		`#{APOLLO_CODEGEN_SCRIPT} generate #{file_path} #{fragments_files_paths} --schema #{SCHEME_FILE_PATH} --output #{GENERATED_FRAGMENTS_DIRECTORY_PATH} --only #{file_path}`
	
		name = File.basename(file_path, File.extname(file_path))
		add_file_to_xcode(xcodeproj, update_xcode_project, GENERATED_FRAGMENTS_DIRECTORY_PATH, name)
	end

	types_file_name = 'Types'
	generated_file_path = "#{GENERATED_FRAGMENTS_DIRECTORY_PATH}/#{types_file_name}.graphql.swift"
	
	return unless File.exist?(generated_file_path)

	line_count = `wc -l "#{generated_file_path}"`.strip.split(' ')[0].to_i

	if line_count > 2
		File.file?(generated_file_path)
		generated_file_name = "#{types_file_name}.swift"
		generated_new_file_path = "#{GENERATED_FILES_PATH}/#{generated_file_name}"
		
		File.rename(generated_file_path, generated_new_file_path)

		if update_xcode_project
			file = final_group(xcodeproj, GENERATED_FILES_PATH).new_file("#{generated_file_name}")
			xcodeproj.targets.first.add_file_references([file])
		end
	else
		File.delete(generated_file_path)
	end
end

def generate_requests(xcodeproj, update_xcode_project)
	fragments_files_paths = Dir["#{FRAGMENTS_DIRECTORY_PATH}/*.graphql"].each.map { |file_path| file_path }.join(" ")

	Dir["#{REQUESTS_DIRECTORY_PATH}/*.graphql"].each do |file_path|
		`#{APOLLO_CODEGEN_SCRIPT} generate #{file_path} #{fragments_files_paths} --schema #{SCHEME_FILE_PATH} --output #{GENERATED_REQUESTS_DIRECTORY_PATH} --only #{file_path}`
		
		name = File.basename(file_path, File.extname(file_path))
		add_file_to_xcode(xcodeproj, update_xcode_project, GENERATED_REQUESTS_DIRECTORY_PATH, name)
	end

	path_to_file = "#{GENERATED_REQUESTS_DIRECTORY_PATH}/Types.graphql.swift"
	File.delete(path_to_file) if File.exist?(path_to_file)
end

def final_group(xcodeproj, directory_path)
	final_group = xcodeproj

	directory_path.split("/").each do |component|
		next_group = final_group[component]
		final_group = next_group if next_group
	end

	return final_group
end

def add_file_to_xcode(xcodeproj, update_xcode_project, directory_path, name)
	generated_file_path = "#{directory_path}/#{name}.graphql.swift"

	if File.file?(generated_file_path)
		generated_file_name = "#{name}.swift"
		generated_new_file_path = "#{directory_path}/#{generated_file_name}"
		
		File.rename(generated_file_path, generated_new_file_path)

		if update_xcode_project
			file = final_group(xcodeproj, directory_path).new_file("#{generated_file_name}")
			xcodeproj.targets.first.add_file_references([file])
		end
	end
end

# Programm

if `git status #{FRAGMENTS_DIRECTORY_PATH} --porcelain`.empty? && `git status #{REQUESTS_DIRECTORY_PATH} --porcelain`.empty?
	puts '[apollo-codegen]: No changes'
	exit
end

xcodeproj = Xcodeproj::Project.open(XCODEPROJ_PATH)

update_xcode_project = need_update_xcode_project

if update_xcode_project
	remove_all_files_from(xcodeproj, Dir["#{Dir.pwd}/#{GENERATED_FRAGMENTS_DIRECTORY_PATH}/*.swift"])
	remove_all_files_from(xcodeproj, Dir["#{Dir.pwd}/#{GENERATED_REQUESTS_DIRECTORY_PATH}/*.swift"])
	remove_all_files_from(xcodeproj, Dir["#{Dir.pwd}/#{GENERATED_FILES_PATH}/*.swift"])
end

generate_fragments(xcodeproj, update_xcode_project)
generate_requests(xcodeproj, update_xcode_project)

xcodeproj.save if update_xcode_project
