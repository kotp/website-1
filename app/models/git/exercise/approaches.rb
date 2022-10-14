class Git::Exercise::Approaches
  extend Mandate::Memoize
  extend Mandate::InitializerInjector
  extend Git::HasGitFilepath

  delegate :head_sha, :lookup_commit, :head_commit, to: :repo

  git_filepath :introduction, file: "introduction.md"
  git_filepath :config, file: "config.json"

  def initialize(exercise_slug, exercise_type, git_sha = "HEAD", repo_url: nil, repo: nil)
    @repo = repo || Git::Repository.new(repo_url:)
    @exercise_slug = exercise_slug
    @exercise_type = exercise_type
    @git_sha = git_sha
  end

  def synced_git_sha = commit.oid

  memoize
  def introduction_authors = config_introduction[:authors].to_a

  memoize
  def introduction_contributors = config_introduction[:contributors].to_a

  memoize
  def introduction_last_modified_at
    return unless introduction_exists?

    repo.file_last_modified_at(introduction_absolute_filepath)
  end

  memoize
  def absolute_filepaths
    filepaths.map { |filepath| absolute_filepath(filepath) }
  end

  def filepaths = file_entries.map { |defn| defn[:full] }

  def read_file_blob(filepath)
    mapped = file_entries.map { |f| [f[:full], f[:oid]] }.to_h
    mapped[filepath] ? repo.read_blob(mapped[filepath]) : nil
  end

  def dir = "exercises/#{exercise_type}/#{exercise_slug}/.approaches"

  private
  attr_reader :repo, :exercise_slug, :exercise_type, :git_sha

  memoize
  def config_introduction = config[:introduction].to_h
  def absolute_filepath(filepath) = "#{dir}/#{filepath}"

  memoize
  def file_entries
    tree.walk(:preorder).map do |root, entry|
      next if entry[:type] == :tree

      entry[:full] = "#{root}#{entry[:name]}"
      entry
    end.compact
  rescue Rugged::TreeError
    []
  end

  memoize
  def tree = repo.fetch_tree(commit, dir)

  memoize
  def commit = repo.lookup_commit(git_sha)

  memoize
  def track = Track.new(repo:)
end
