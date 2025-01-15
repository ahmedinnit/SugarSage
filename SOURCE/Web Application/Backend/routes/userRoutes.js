const express = require("express");

// Importing Logic
const {
  getProfile,
  updateProfile,
} = require("../controllers/user/profileController");

const {
  getHealthProfile,
  updateHealthProfile,
} = require("../controllers/user/healthProfileController");

const { healthTrack } = require("../controllers/user/healthStatsController");
const { getAllBlogs } = require("../controllers/user/blogController");

const { postFeedback } = require("../controllers/user/feedbackController");

// Router Object
const router = express.Router();
const { verifyToken } = require("../verifyToken");
const multer = require("multer");
const {
  MealPlanMobile,
  generateMealPlan,
  storeMealPlan,
  storeCals,
  checkMealPlan,
  getMealPlan,
} = require("../controllers/user/mealPlanController");
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// Dashboard
router.post("/dashboard/:id", verifyToken, healthTrack);

// Meal Plans
router.post("/mealplans/generate/:id", verifyToken, generateMealPlan);
router.post("/mealplans/store/:id", verifyToken, storeMealPlan);
router.post("/mealplans/storeCals/:id", verifyToken, storeCals);
router.get("/mealplans/check/:id", verifyToken, checkMealPlan);
router.get("/mealplans/get/:id", verifyToken, getMealPlan);
// router.post("/mealplans/mobile/generate/:id", verifyToken, MealPlanMobile);

// Health Tracker
// router.post("/healthtracker/:id", verifyToken, healthTrack);

// Feedback
router.post("/feedback/:id", verifyToken, postFeedback);

// Blogs
router.get("/blogs/getAll", verifyToken, getAllBlogs);

// User Profile
router.post("/profile/get/:id", upload.none(), verifyToken, getProfile);
router.put("/profile/update/:id", upload.none(), verifyToken, updateProfile);
router.delete("/profile/delete/:id");

// Health Profile
router.post("/healthprofile/get/:id", verifyToken, getHealthProfile);
router.put("/healthprofile/update/:id", verifyToken, updateHealthProfile);

module.exports = router;
