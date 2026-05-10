# Sherry Content Board - Clean Rebuild Plan

## Project Overview
Rebuild the video management dashboard from scratch with clean architecture, proper mobile responsiveness, and robust Supabase integration.

## Technical Stack
- **Frontend**: Vanilla JavaScript (ES6+), HTML5, CSS3
- **Backend**: Supabase (PostgreSQL + Realtime)
- **Video Hosting**: Cloudinary + YouTube support
- **Deployment**: Static hosting with CDN dependencies

## Core Features
1. **Video Management**
   - Add/Edit/Delete videos with instant UI updates
   - Support for Cloudinary and YouTube URLs
   - Category-based organization
   - View count tracking

2. **Shot Management**
   - Inline shot editing with real-time persistence
   - Add/remove shots with immediate database sync
   - Shot count tracking

3. **Responsive Design**
   - Mobile-first approach (320px+)
   - Tablet breakpoint (768px+)
   - Desktop breakpoint (1024px+)
   - Touch-friendly interactions

4. **Performance**
   - Lazy loading for video metadata
   - Optimized re-renders
   - Minimal DOM manipulation
   - Efficient state management

## Architecture

### State Management
```javascript
class AppState {
  constructor() {
    this.videos = [];
    this.shots = {};
    this.categories = ['Thuis', 'Feria', 'Tussendoor', 'Veel werk', 'Tsja', 'Klaar'];
    this.loading = false;
    this.error = null;
  }
  
  async loadState() { /* Supabase fetch */ }
  async saveVideo(video) { /* Supabase upsert */ }
  async deleteVideo(id) { /* Supabase delete */ }
  async updateShots(videoId, shots) { /* Supabase update */ }
}
```

### Component Structure
```javascript
class VideoCard {
  constructor(video, shots, onEdit, onDelete, onShotUpdate)
  render() { /* Card HTML */ }
  updateVideo(video) { /* Update UI */ }
  updateShots(shots) { /* Update shots UI */ }
}

class Modal {
  constructor()
  open(mode, video?) { /* Add/Edit mode */ }
  close() { /* Reset and hide */ }
  save() { /* Validate and submit */ }
}
```

### Database Schema
```sql
-- videos table
CREATE TABLE videos (
  id INTEGER PRIMARY KEY,
  num INTEGER UNIQUE,
  title TEXT NOT NULL,
  views TEXT,
  url TEXT NOT NULL,
  category TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- shots table  
CREATE TABLE shots (
  id SERIAL PRIMARY KEY,
  video_id INTEGER REFERENCES videos(id) ON DELETE CASCADE,
  count INTEGER DEFAULT 0,
  list TEXT[] DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

## CSS Architecture
```css
/* Mobile-first responsive design */
.container { max-width: 1200px; margin: 0 auto; }
.grid { display: grid; gap: 1rem; }
@media (min-width: 768px) { .grid { grid-template-columns: repeat(2, 1fr); } }
@media (min-width: 1024px) { .grid { grid-template-columns: repeat(3, 1fr); } }
.card { background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
.video { width: 100%; border-radius: 6px; }
```

## Implementation Phases

### Phase 1: Foundation (Day 1)
- [ ] Set up clean HTML structure with semantic markup
- [ ] Implement responsive CSS grid layout
- [ ] Create Supabase client initialization
- [ ] Build basic state management class

### Phase 2: Core Features (Day 1-2)
- [ ] Implement video CRUD operations
- [ ] Build video card components
- [ ] Create modal for add/edit
- [ ] Add shot management functionality

### Phase 3: Enhancement (Day 2)
- [ ] Add category filtering and organization
- [ ] Implement search functionality
- [ ] Add video preview/thumbnail support
- [ ] Optimize performance with lazy loading

### Phase 4: Polish (Day 2-3)
- [ ] Mobile responsiveness testing and fixes
- [ ] Accessibility improvements
- [ ] Error handling and loading states
- [ ] Performance optimization

## File Structure
```
index.html          # Single-page application
├── styles/          # CSS organization
│   ├── base.css     # Base styles and variables
│   ├── layout.css    # Grid and responsive layout
│   └── components.css # Cards, modals, forms
├── scripts/          # JavaScript organization
│   ├── supabase.js   # Database operations
│   ├── components.js  # UI components
│   └── app.js        # Main application logic
└── assets/           # Static assets
    └── icons/         # UI icons
```

## Success Criteria
1. **Functionality**: All CRUD operations work seamlessly
2. **Performance**: <2s initial load, <500ms interactions
3. **Mobile**: Fully functional on 320px+ devices
4. **Accessibility**: WCAG 2.1 AA compliance
5. **Code Quality**: <1200 lines, clear separation of concerns
6. **User Experience**: Intuitive, responsive, error-free

## Deployment
- **Development**: Live reload with Vite or similar
- **Production**: Static hosting with CDN dependencies
- **Environment**: Configurable Supabase endpoints
- **Monitoring**: Error tracking and performance metrics
