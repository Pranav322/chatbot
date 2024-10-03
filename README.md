# Movie Recommender Diary

Movie Recommender Diary is a Flutter application that combines a personal diary with movie recommendations. Users can write diary entries and receive movie suggestions based on their mood or the content of their entries.

## Features

- Create, edit, and delete diary entries
- View diary entries in a visually appealing grid layout
- Get movie recommendations based on diary entries or current mood
- Chat with an AI-powered chatbot for personalized movie suggestions

## Technologies Used

- Flutter
- Dart
- Google Fonts
- SharedPreferences for local storage
- HTTP package for API requests
- cohere api

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/pranav322/chatbot.git
   ```

2. Navigate to the project directory:
   ```
   cd chatbot
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

- `lib/main.dart`: Entry point of the application
- `lib/screens/`: Contains the main screens of the app
- `lib/widgets/`: Reusable UI components
- `lib/models/`: Data models
- `lib/services/`: Services for API calls and data management
- `lib/utils/`: Utility classes and constants

## Key Components

### Diary Entries

Users can create, view, edit, and delete diary entries. Each entry is displayed as a card in a staggered grid view on the home screen.

### Chatbot

The app features a floating chatbot that users can interact with to get movie recommendations based on their diary entries or current mood.

### Movie Recommendations

The app uses an external API to generate movie recommendations based on the content of diary entries or the user's described mood.

## API Integration

The app communicates with a backend service to get movie recommendations. The API endpoint is defined in `lib/utils/constants.dart`.
The api code can be found [here](https://github.com/pranav322/chatbot-backend)

## Contributing

why qould you contribute in this bro 

## License

you can steam 


## Screenshots

Here are some screenshots of the Movie Recommender Diary app:

<details>
  <summary>Click to view screenshots</summary>

  - [Home Screen](screenshots/homepage.jpg)
  - [Add Entry Screen](screenshots/adddiaryentry.jpg)
  - [Chatbot Interaction](screenshots/chatbot.jpg)
  - [Edit or Delete Diary](screenshots/editordelete.jpg)

</details>



## Acknowledgments

- noone