struct MockFetchUserDetailSuccess {
    let loginUsername: String
    let mockJSON: String
    
    static let mocks: [Self] = [
        .init(
            loginUsername: "BrianTheCoder",
            mockJSON: """
                {
                  "login": "BrianTheCoder",
                  "id": 102,
                  "node_id": "MDQ6VXNlcjEwMg==",
                  "avatar_url": "https://avatars.githubusercontent.com/u/102?v=4",
                  "gravatar_id": "",
                  "url": "https://api.github.com/users/BrianTheCoder",
                  "html_url": "https://github.com/BrianTheCoder",
                  "followers_url": "https://api.github.com/users/BrianTheCoder/followers",
                  "following_url": "https://api.github.com/users/BrianTheCoder/following{/other_user}",
                  "gists_url": "https://api.github.com/users/BrianTheCoder/gists{/gist_id}",
                  "starred_url": "https://api.github.com/users/BrianTheCoder/starred{/owner}{/repo}",
                  "subscriptions_url": "https://api.github.com/users/BrianTheCoder/subscriptions",
                  "organizations_url": "https://api.github.com/users/BrianTheCoder/orgs",
                  "repos_url": "https://api.github.com/users/BrianTheCoder/repos",
                  "events_url": "https://api.github.com/users/BrianTheCoder/events{/privacy}",
                  "received_events_url": "https://api.github.com/users/BrianTheCoder/received_events",
                  "type": "User",
                  "user_view_type": "public",
                  "site_admin": false,
                  "name": "Brian Smith",
                  "company": "DSTLD",
                  "blog": "http://brianthecoder.com",
                  "location": "Santa Monica,CA",
                  "email": null,
                  "hireable": null,
                  "bio": null,
                  "twitter_username": null,
                  "public_repos": 109,
                  "public_gists": 184,
                  "followers": 101,
                  "following": 32,
                  "created_at": "2008-01-30T02:22:32Z",
                  "updated_at": "2020-11-06T04:09:16Z"
                }
            """
        ),
        .init(
            loginUsername: "wayneeseguin",
            mockJSON: """
                {
                  "login": "wayneeseguin",
                  "id": 18,
                  "node_id": "MDQ6VXNlcjE4",
                  "avatar_url": "https://avatars.githubusercontent.com/u/18?v=4",
                  "gravatar_id": "",
                  "url": "https://api.github.com/users/wayneeseguin",
                  "html_url": "https://github.com/wayneeseguin",
                  "followers_url": "https://api.github.com/users/wayneeseguin/followers",
                  "following_url": "https://api.github.com/users/wayneeseguin/following{/other_user}",
                  "gists_url": "https://api.github.com/users/wayneeseguin/gists{/gist_id}",
                  "starred_url": "https://api.github.com/users/wayneeseguin/starred{/owner}{/repo}",
                  "subscriptions_url": "https://api.github.com/users/wayneeseguin/subscriptions",
                  "organizations_url": "https://api.github.com/users/wayneeseguin/orgs",
                  "repos_url": "https://api.github.com/users/wayneeseguin/repos",
                  "events_url": "https://api.github.com/users/wayneeseguin/events{/privacy}",
                  "received_events_url": "https://api.github.com/users/wayneeseguin/received_events",
                  "type": "User",
                  "user_view_type": "public",
                  "site_admin": false,
                  "name": "Wayne E Seguin",
                  "company": "FiveTwenty Inc.",
                  "blog": "",
                  "location": "Buffalo, NY",
                  "email": null,
                  "hireable": null,
                  "bio": "R&D",
                  "twitter_username": "wayneeseguin",
                  "public_repos": 109,
                  "public_gists": 95,
                  "followers": 768,
                  "following": 19,
                  "created_at": "2008-01-13T06:02:21Z",
                  "updated_at": "2025-02-23T12:32:41Z"
                }
            """
        )
    ]
}
