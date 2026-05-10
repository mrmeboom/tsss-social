# Sherry Content Board - Deployment Guide

## Quick Start Commands

### Git Setup
```bash
# Initialize git repository (if not already done)
git init

# Add all files to git
git add .

# Commit the clean rebuild
git commit -m "Complete rebuild: Clean architecture with modern responsive design"
```

### Supabase Database Management

#### Clear Database (Fresh Start)
```sql
-- Option 1: Clear all data via SQL
TRUNCATE TABLE videos CASCADE;
TRUNCATE TABLE shots CASCADE;

-- Option 2: Delete specific records (more selective)
DELETE FROM videos WHERE id IN (1,2,3,4,5,6,7,8,9,10,11);
DELETE FROM shots WHERE video_id IN (1,2,3,4,5,6,7,8,9,10,11);
```

#### Access Supabase Dashboard
1. Go to [https://supabase.com/dashboard](https://supabase.com/dashboard)
2. Select your project: `gyavdaefgzmsuvtufzfr`
3. Go to **SQL Editor**
4. Run one of the clearing commands above
5. Click **Run** to execute

## Deployment Options

### Option 1: Static Hosting (Recommended)
```bash
# Serve locally for testing
python3 -m http.server 8000

# Deploy to any static hosting service
# - Netlify, Vercel, GitHub Pages, etc.
```

### Option 2: Platform with Build Step
```bash
# If using platforms that require build step
npm run build  # If package.json exists
# Then deploy dist/ folder
```

## Final Verification Checklist

- [ ] Replace `index.html` with clean version
- [ ] Test all CRUD operations work
- [ ] Verify mobile responsiveness
- [ ] Clear database if starting fresh
- [ ] Commit changes to git
- [ ] Deploy to hosting service

## Architecture Summary

The new implementation features:
- **Clean Class-Based State Management**
- **Mobile-First Responsive Design**  
- **Modern Supabase Integration**
- **Component-Style Architecture**
- **Performance Optimizations**
- **No Legacy Code or Debug Artifacts**

## Support

For any issues with the clean rebuild:
1. Check browser console for errors
2. Verify Supabase connection in network tab
3. Test mobile responsiveness via dev tools
4. Review PROJECT_PLAN.md for technical details

The clean rebuild is production-ready and follows modern web development best practices.
