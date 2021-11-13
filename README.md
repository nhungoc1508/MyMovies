# MyMovies

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
MyMovies is a movie search and collection app. This app allows users to not only browse and search the movie database but create collections of movies. Movie collections allow them to store their holiday favorites or superhero movies and share with other users, or to get recommendations based on their collections. 

### App Evaluation
- **Category:** Movies
- **Mobile:** iOS
- **Story:** This app would be awesome for our peers as they can keep track of movies and make lists of movies to show friends.
- **Market:** Almost everyone watches movies making the market anyone in the world who enjoys watching movies and sharing what they watch.
- **Habit:** Users will use this a lot as people are always watching movies and a user creates collections.
- **Scope:** This scope allows for something that is probable to build within the timeframe, but also has optional stories if finished too quickly. We will add additional recommendation system if time permits.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can register new account and sign in
* User stays logged in across app restarts
* User can browse movies and search by name
* User can create new collections and add movies in
* User can see collections they have created and modify them (remove movies, add new movies, delete collections)

**Optional Nice-to-have Stories**

* User can search by genre, actor name
* User can share their collections
* User can view others collections
* User can get recommended collections by other users
* User can get recommended movies by the system

### 2. Screen Archetypes

* Login / Register
   * User can sign up or log into their account
* Stream
   * User can browse top movies
   * User can search for movies by names using the search bar
   * User can view their collections
* Detail
    * User can see movie details in browser
    * User can see details of specific collection 
* Creation
    * User can create a new movie collection
* Profile
    * User can see their own information and names of collections they've created
* Settings
    * User can change their information
    * User can change privacy settings (whether to keep their collections private or public, etc.)

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Movie feed
* User collections
* User profile

**Flow Navigation** (Screen to Screen)

* Login/Register
   * → Movie feed
* Movie Feed
   * → Movie details → User collections
* User collections
    * → Movie feed
    * → Movie details

## Wireframes

<img src="https://i.imgur.com/uENCo0U.png" width=600>
<img src="https://imgur.com/9fnpzjs.png" width=600>
<img src="https://imgur.com/eLeYQxG.png" width=600>

### Interactive Prototype
<img src="https://media.giphy.com/media/saLB5gAhH7HWRfTdSL/giphy.gif" width=250>
<img src="https://media.giphy.com/media/XcAkxR20Ok1YDye0X0/giphy.gif" width=250>

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
