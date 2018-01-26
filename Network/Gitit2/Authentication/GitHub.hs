{-# LANGUAGE OverloadedStrings #-}
module Network.Gitit2.Authentication.GitHub
    ( oauth2GitHubUsingLogin
    , defaultScopes
    , orgScopes
    ) where

import Data.Aeson ((.:), FromJSON, parseJSON, withObject)
import Data.Text
import Yesod.Auth.OAuth2.Github (defaultScopes)
import Yesod.Auth.OAuth2.Provider

newtype Login = Login Text
    deriving ToIdent

instance FromJSON Login where
    parseJSON = withObject "Login" $ \o -> Login <$> o .: "login"

oauth2GitHubUsingLogin :: [Scope] -> Provider m Login
oauth2GitHubUsingLogin scopes = Provider
    { pName = "github"
    , pAuthorizeEndpoint = const $ AuthorizeEndpoint
        $ "http://github.com/login/oauth/authorize" `withQuery`
            [ scopeParam "," scopes
            ]
    , pAccessTokenEndpoint = "http://github.com/login/oauth/access_token"
    , pFetchUserProfile = authGetProfile "https://api.github.com/user"
    }

orgScopes :: [Scope]
orgScopes = "read:org" : defaultScopes