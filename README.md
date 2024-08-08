# Scribit

<img width="84" alt="scribitlogo" src="https://github.com/user-attachments/assets/d17c5e92-79ab-40e7-9a82-8407fd1bde4a">

Scribit is a feature-rich sketch pad app built with SwiftUI, leveraging the power of PencilKit to provide a natural and responsive drawing experience. 
The app allows users to draw add draggable shapes, draggable text, and enjoy a fully functional undo/redo system. 
This project serves as a great example of integrating UIKit components like PencilKit with SwiftUI for a modern iOS application.

## Features

- **Login and sign up:** This app uses firebase authentication to log in and sign up users.
- **Drawing Tools:** Use the PencilKit drawing tools with a custom tool picker interface.
- **Shapes and Texts:** Add and drag shapes or text around the canvas with ease.
- **Undo/Redo Support:** Comprehensive undo/redo functionality for all canvas actions.
- **Zoom & Pan:** Utilize pinch-to-zoom and pan functionality for a closer look at your drawings.

## Screenshots


## Installation

1. **Clone the Repository:**
    ```bash
    git clone https://github.com/yourusername/scribit.git
    ```

2. **Open in Xcode:**
   - Open `Scribit.xcodeproj` in Xcode.
   - Ensure you have the latest version of Xcode and are running macOS 11.0 or later.

3. **Build and Run:**
   - Select your target device or simulator.
   - Click the "Run" button in Xcode.

## Usage

- **Home Screen:**
  - View a list of all saved canvases.
  - Create a new canvas using the "+" button.
  - Tap on a canvas to open and edit it.
  - Swipe left on a canvas to delete it.

- **Canvas View:**
  - Use the tool picker to select drawing tools, add shapes, or insert text.
  - Drag and reposition shapes and text as needed.
  - Use the undo/redo buttons to correct mistakes.
  - Your work is automatically saved when you return to the home screen.

## Code Overview

### Key Components

- **CanvasListView.swift:** Displays a list of canvases and allows users to create, select, or delete them.
- **CanvasView.swift:** The main drawing interface where users interact with the canvas.
- **ViewModel.swift:** Manages the state and logic for `CanvasView`, including drawing, shapes, and text.
- **DrawingView.swift:** A `UIViewRepresentable` component that integrates PencilKit's `PKCanvasView` into SwiftUI.
- **ToolPickerView.swift:** Provides the UI for selecting drawing tools, adding shapes, and inserting text.
- **ShapeSelectView.swift:** Allows users to select from different shape types to add to the canvas.

### Future Improvements

- **Persistence:** Implement more robust data storage using Core Data or other persistence mechanisms.
- **Shape Customization:** Allow users to customize shape colors, sizes, and styles.
- **Export Options:** Add the ability to export drawings as images or PDFs.

## Contributing

Contributions are welcome! Please fork this repository and submit a pull request for any enhancements or bug fixes.

Feel free to explore the code, suggest improvements, or report issues. Happy drawing!

