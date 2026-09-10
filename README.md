# TheContentHub

TheContentHub is a full-stack blogging platform built with Ruby on Rails. It allows users to register, log in, create and manage articles, upload cover images, search content, interact through comments, and browse articles using pagination.

The project was developed as part of my Ruby on Rails training and focuses on MVC architecture, authentication, authorization, testing, security, CI/CD, and production deployment.

## Features

- User registration, login, and logout using Devise
- Create, read, update, and delete articles
- Ownership-based authorization for articles and comments
- Comment system with user associations
- Optional article image uploads using Active Storage
- Friendly URLs using FriendlyId
- Article search
- Categories and article status management
- User profiles
- Pagination using Pagy
- Responsive UI with Bootstrap
- Database query optimization using Bullet
- Automated tests using Minitest
- Security scanning using Brakeman
- Code quality checks using RuboCop
- JavaScript dependency auditing using Importmap
- Continuous Integration using GitHub Actions
- PostgreSQL production database
- Deployment on Render

## Tech Stack

### Backend
- Ruby
- Ruby on Rails
- Active Record

### Frontend
- HTML
- ERB
- Bootstrap
- JavaScript
- Importmap

### Database
- SQLite for development and testing
- PostgreSQL for production

### Gems and Tools
- Devise
- FriendlyId
- Active Storage
- Pagy
- Bullet
- Minitest
- RuboCop
- Brakeman

### DevOps
- Git
- GitHub
- GitHub Actions
- Render

## Architecture

The application follows the MVC architecture used by Ruby on Rails.

- **Model** — Handles application data, validations, associations, and database interaction.
- **View** — Displays application data using HTML and ERB templates.
- **Controller** — Handles incoming requests, communicates with models, and decides which views to render.

Typical request flow:

Browser → Routes → Controller → Model → Database → Controller → View → Browser

## Main Models

### User
A user can create multiple articles and comments.

### Article
An article belongs to a user and can have multiple comments.

### Comment
A comment belongs to both a user and an article.

Relationship overview:

User → has many Articles  
User → has many Comments  
Article → has many Comments  
Article → belongs to User  
Comment → belongs to User  
Comment → belongs to Article

## Authentication and Authorization

Authentication is handled using Devise.

Users can:

- Register
- Log in
- Log out
- Maintain authenticated sessions

Authorization rules ensure users can only edit or delete content they own.

## Article Management

The application supports complete CRUD functionality:

- Create articles
- View articles
- Edit articles
- Delete articles

Articles can also contain:

- Title
- Body
- Category
- Status
- Cover image
- Friendly URL slug

## Image Uploads

Active Storage is used to manage article image uploads.

In development, files can be stored locally. For production applications, cloud storage such as Amazon S3, Google Cloud Storage, or Cloudflare R2 can be configured.

## Search

Users can search articles using keywords.

The search feature filters articles based on content such as article titles and body text.

## Pagination

Pagy is used to paginate the article list, improving performance and preventing large numbers of records from loading on a single page.

## Performance Optimization

Bullet is used during development to detect inefficient database queries such as N+1 queries.

Related records are loaded using Active Record eager loading where required.

## Testing

The application uses Rails Minitest.

Current test suite:

- 9 test runs
- 15 assertions
- 0 failures
- 0 errors
- 0 skipped tests

Run tests with:

```bash
bin/rails test
