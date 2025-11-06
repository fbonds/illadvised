# Marketing Materials Setup - Complete ✅

## What Was Done

### 1. Created Marketing Folder Structure
- Created `/marketing/` directory in project root
- Moved `Ill_Advised_App_Video_Generation.mp4` to `/marketing/`
- Created `marketing/README.md` with usage guidelines

### 2. Updated Main README.md
Added new "Marketing Materials" section with:
- Video preview link (GitHub raw URL)
- Download link for local viewing
- Description of video content
- App Store submission guidance
- Formatting follows GitHub best practices

### 3. Updated .gitignore
- Modified to allow marketing videos in git
- Added exception: `!marketing/*.mp4` and `!marketing/*.mov`
- Ensures promotional materials are version controlled

## File Locations

```
/Users/fletcher/Documents/illadvised2/
├── marketing/
│   ├── Ill_Advised_App_Video_Generation.mp4  (6.4 MB)
│   └── README.md
├── README.md (updated with Marketing Materials section)
└── .gitignore (updated to allow marketing videos)
```

## How the Video Appears in README

The video is referenced in the README in two ways:

1. **GitHub Raw Link** (for direct viewing):
   ```
   https://github.com/fbonds/illadvised/raw/main/marketing/Ill_Advised_App_Video_Generation.mp4
   ```

2. **Relative Download Link** (for local repos):
   ```
   [⬇️ Download Video](marketing/Ill_Advised_App_Video_Generation.mp4)
   ```

**Note:** GitHub doesn't natively play MP4 videos inline in README files, so users will need to:
- Click the download link to view locally
- Or click the raw GitHub URL which downloads the file

## Next Steps

### To Commit These Changes:

```bash
cd /Users/fletcher/Documents/illadvised2

# Add all the changes
git add .gitignore README.md marketing/

# Commit with descriptive message
git commit -m "Add marketing materials: promotional video and updated README

- Created marketing/ folder for promotional assets
- Added Ill_Advised_App_Video_Generation.mp4 (6.4MB)
- Updated README.md with Marketing Materials section
- Modified .gitignore to allow marketing videos
- Added marketing/README.md with usage guidelines

Co-authored-by: factory-droid[bot] <138933559+factory-droid[bot]@users.noreply.github.com>"

# Push to GitHub
git push
```

### After Pushing to GitHub:

The video will be accessible via:
1. **Direct link in README**: Viewers can click to download
2. **Raw GitHub URL**: Direct download from GitHub servers
3. **Clone/pull**: Other developers get the video automatically

## App Store Submission Tips

From the marketing/README.md, for App Store submission:

**Video Requirements:**
- Length: 15-30 seconds (current video may need editing)
- Format: .mov or .mp4 ✓ (you have .mp4)
- Resolution: 1080p or higher (check your video specs)
- Orientation: Portrait for iPhone apps

**To Edit for App Store:**
1. Extract best 15-30 seconds
2. Focus on dual-camera and sensor overlay
3. Add text overlays if needed
4. Consider background music
5. End with app icon/name

**Video Editing Tools:**
- iMovie (Mac/iOS - free)
- Final Cut Pro (Mac - professional)
- Adobe Premiere (cross-platform)
- DaVinci Resolve (free, powerful)

## Marketing Folder Contents

### Current Files:
- ✅ `Ill_Advised_App_Video_Generation.mp4` - Promotional video (6.4 MB)
- ✅ `README.md` - Usage guidelines and tips

### Future Assets to Add:
- App icon designs (1024x1024 for App Store)
- Screenshots in required sizes
- Social media graphics
- Press kit materials
- Demo GIFs for documentation

## Viewing the Video

### Locally:
```bash
open /Users/fletcher/Documents/illadvised2/marketing/Ill_Advised_App_Video_Generation.mp4
```

### After GitHub Push:
Visit: `https://github.com/fbonds/illadvised/tree/main/marketing`

### In README:
After pushing, the README on GitHub will show the Marketing Materials section with download links.

## Testing the Setup

1. ✅ Video moved to correct location
2. ✅ README updated with marketing section
3. ✅ .gitignore configured to allow marketing videos
4. ✅ Marketing README created with guidelines
5. ⏳ Ready to commit and push

## GitHub Display Note

**Important:** GitHub markdown doesn't support embedded video playback. The video will appear as:
- A clickable download link
- A raw file URL
- Users can download and view locally

**Alternative for Better Preview:**
Consider also creating:
1. **Animated GIF** (from video clips) - displays inline on GitHub
2. **YouTube/Vimeo upload** - embed with thumbnail
3. **GitHub Releases** - attach video to release for better visibility

Would you like me to help create a GIF preview from the video for better GitHub display?

## Summary

✅ **Marketing materials are organized and ready to commit!**

The video is now:
- In the correct folder (`marketing/`)
- Referenced in the main README
- Exempt from .gitignore
- Documented with usage guidelines
- Ready for version control

Just commit and push when ready!
