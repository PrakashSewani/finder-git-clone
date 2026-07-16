import Testing
@testable import FinderGitCloneCore

@Suite("GitURL Tests")
struct GitURLTests {
    @Test("Parse HTTPS URL")
    func parseHTTPS() {
        let url = GitURL(string: "https://github.com/user/repo.git")
        #expect(url.isValid == true)
        #expect(url.scheme == .https)
        #expect(url.host == "github.com")
        #expect(url.repositoryName == "repo")
        #expect(url.isSSH == false)
    }

    @Test("Parse SSH URL")
    func parseSSH() {
        let url = GitURL(string: "git@github.com:user/repo.git")
        #expect(url.isValid == true)
        #expect(url.scheme == .ssh)
        #expect(url.host == "github.com")
        #expect(url.repositoryName == "repo")
        #expect(url.isSSH == true)
    }

    @Test("Parse SSH URL with protocol")
    func parseSSHWithProtocol() {
        let url = GitURL(string: "ssh://git@github.com/user/repo.git")
        #expect(url.isValid == true)
        #expect(url.scheme == .ssh)
        #expect(url.host == "github.com")
        #expect(url.repositoryName == "repo")
        #expect(url.isSSH == true)
    }

    @Test("Parse Git protocol URL")
    func parseGitProtocol() {
        let url = GitURL(string: "git://github.com/user/repo.git")
        #expect(url.isValid == true)
        #expect(url.scheme == .git)
        #expect(url.host == "github.com")
        #expect(url.repositoryName == "repo")
    }

    @Test("Parse Azure DevOps URL")
    func parseAzureDevOps() {
        let url = GitURL(string: "https://dev.azure.com/myorg/myproject/_git/myrepo")
        #expect(url.isValid == true)
        #expect(url.scheme == .https)
        #expect(url.host == "dev.azure.com")
        #expect(url.repositoryName == "myrepo")
    }

    @Test("Parse local file path")
    func parseLocalPath() {
        let url = GitURL(string: "/Users/dev/projects/repo")
        #expect(url.isValid == true)
        #expect(url.scheme == .file)
        #expect(url.repositoryName == "repo")
        #expect(url.isSSH == false)
    }

    @Test("Parse tilde path")
    func parseTildePath() {
        let url = GitURL(string: "~/projects/repo")
        #expect(url.isValid == true)
        #expect(url.scheme == .file)
    }

    @Test("Parse relative path")
    func parseRelativePath() {
        let url = GitURL(string: "../repo")
        #expect(url.isValid == true)
        #expect(url.scheme == .file)
    }

    @Test("Invalid empty URL")
    func invalidEmpty() {
        let url = GitURL(string: "")
        #expect(url.isValid == false)
        #expect(url.validationError != nil)
    }

    @Test("Invalid URL without host")
    func invalidNoHost() {
        let url = GitURL(string: "https://")
        #expect(url.isValid == false)
    }

    @Test("Invalid random text")
    func invalidRandom() {
        let url = GitURL(string: "not a url")
        #expect(url.isValid == false)
        #expect(url.validationError != nil)
    }

    @Test("Repository name strips .git suffix")
    func stripsGitSuffix() {
        let url = GitURL(string: "https://github.com/user/repo.git")
        #expect(url.repositoryName == "repo")
    }

    @Test("Repository name without .git suffix")
    func noGitSuffix() {
        let url = GitURL(string: "https://github.com/user/repo")
        #expect(url.repositoryName == "repo")
    }

    @Test("Display name includes host")
    func displayName() {
        let url = GitURL(string: "https://github.com/user/repo.git")
        #expect(url.displayName == "github.com/repo")
    }

    @Test("SSH URL is valid")
    func sshIsValid() {
        let url = GitURL(string: "git@gitlab.com:team/project.git")
        #expect(url.isValid == true)
        #expect(url.host == "gitlab.com")
    }

    @Test("Bitbucket URL")
    func bitbucketURL() {
        let url = GitURL(string: "https://bitbucket.org/team/repo.git")
        #expect(url.isValid == true)
        #expect(url.host == "bitbucket.org")
        #expect(url.repositoryName == "repo")
    }

    @Test("URL with port")
    func urlWithPort() {
        let url = GitURL(string: "https://github.com:443/user/repo.git")
        #expect(url.isValid == true)
        #expect(url.host == "github.com")
    }

    @Test("URL trimming whitespace")
    func trimsWhitespace() {
        let url = GitURL(string: "  https://github.com/user/repo.git  ")
        #expect(url.isValid == true)
        #expect(url.repositoryName == "repo")
    }
}
