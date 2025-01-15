const db = require("../../config/db");
const { calculateAge } = require("../../methods/calculateAge");
const { calculatePostMealSugar } = require("../../methods/calculatePMS");
const { getTopRecommendedFoods } = require("../../methods/recommendFoods");
const axios = require("axios");

const MealPlanMobile = async (req, res) => {
  try {
    const user_id = req.params.id;
    if (!user_id) {
      return res.status(400).send({
        success: false,
        message: "User ID not Provided",
      });
    }
    const { FBS } = req.body;

    if (!FBS) {
      return res.status(400).send({
        success: false,
        message: "FBS not provided",
      });
    }

    const [[user_info]] = await db.query(
      "SELECT dob, gender FROM Users WHERE user_id=?",
      [user_id]
    );

    const [[user_health]] = await db.query(
      "SELECT BMI, hbA1c FROM HealthProfile WHERE user_id=?",
      [user_id]
    );

    let temp_date = user_info.dob;
    temp_date = temp_date.toISOString();
    const formattedDate = temp_date.split("T")[0];
    const age = calculateAge(formattedDate);

    const [foods_data] = await db.query(
      "SELECT f.food_name as Food, f.GL, COALESCE(l.reaction, 3) AS Reaction FROM Foods f LEFT JOIN Likes l ON f.food_id = l.food_id AND l.user_id=?",
      [user_id]
    );

    const temp_payload = foods_data.map((item) => ({
      ...item,
      Age: Number(age),
      Gender: user_info.gender,
      BMI: Number(user_health.BMI),
      "HbA1c Level": Number(user_health.hbA1c),
      FBS: Number(FBS),
      PMS: calculatePostMealSugar(
        Number(FBS),
        Number(item.GL),
        Number(age),
        Number(user_health.BMI),
        Number(user_health.hbA1c),
        user_info.gender
      ),
    }));

    // Ensure temp_payload is correctly formatted as per the API's expectations
    const formattedPayload = {
      Data: temp_payload,
    };

    const response = await axios.post(
      "https://895f-39-60-249-131.ngrok-free.app/predict_model_02",
      formattedPayload
    );

    const topFoods = getTopRecommendedFoods(response.data.Data, 9, 25, 15);

    const topFoodNames = topFoods.map((food) => food.name);

    // Fetch nutritional details from the database for the top foods
    const placeholders = topFoodNames.map(() => "?").join(",");
    const [rows] = await db.query(
      `SELECT food_name, \`carbs (g)\` as carbs, \`fats (g)\` as fats, \`proteins (g)\` as proteins, \`energy (kCal)\` as energy 
         FROM Foods 
         WHERE food_name IN (${placeholders})`,
      topFoodNames
    );

    const foodDetails = rows.reduce((acc, row) => {
      acc[row.food_name] = {
        carbs: row.carbs,
        fats: row.fats,
        proteins: row.proteins,
        cal: row.energy,
      };
      return acc;
    }, {});

    // Extract the details for the top recommended foods
    const topCarbs = topFoodNames.map((name) => foodDetails[name].carbs);
    const topFats = topFoodNames.map((name) => foodDetails[name].fats);
    const topProteins = topFoodNames.map((name) => foodDetails[name].proteins);
    const topCalories = topFoodNames.map((name) => foodDetails[name].cal);
    const topPredictions = topFoods.map((food) => food.score);

    // Construct the final JSON structure
    const payload_2 = {
      "Top RecScore": {
        food_names: topFoodNames,
        predictions: topPredictions,
        carbs: topCarbs,
        fats: topFats,
        Proteins: topProteins,
        cal: topCalories,
      },
    };

    res.status(200).send({
      success: true,
      message: "Meal Plans generated successfully.",
      data: payload_2,
    });
  } catch (e) {
    console.error(e);
    return res.status(500).send({
      success: false,
      message: "Error in Generate Meal Plan API.",
    });
  }
};

const generateMealPlan = async (req, res) => {
  try {
    const user_id = req.params.id;
    if (!user_id) {
      return res.status(400).send({
        success: false,
        message: "User ID not Provided",
      });
    }
    const { FBS } = req.body;

    if (!FBS) {
      return res.status(400).send({
        success: false,
        message: "FBS not provided",
      });
    }

    const [[user_info]] = await db.query(
      "SELECT dob, gender FROM Users WHERE user_id=?",
      [user_id]
    );

    const [[user_health]] = await db.query(
      "SELECT BMI, hbA1c FROM HealthProfile WHERE user_id=?",
      [user_id]
    );

    let temp_date = user_info.dob;
    temp_date = temp_date.toISOString();
    const formattedDate = temp_date.split("T")[0];
    const age = calculateAge(formattedDate);

    const [foods_data] = await db.query(
      "SELECT f.food_name as Food, f.GL, COALESCE(l.reaction, 3) AS Reaction FROM Foods f LEFT JOIN Likes l ON f.food_id = l.food_id AND l.user_id=?",
      [user_id]
    );

    const temp_payload = foods_data.map((item) => ({
      ...item,
      Age: Number(age),
      Gender: user_info.gender,
      BMI: Number(user_health.BMI),
      "HbA1c Level": Number(user_health.hbA1c),
      FBS: Number(FBS),
      PMS: calculatePostMealSugar(
        Number(FBS),
        Number(item.GL),
        Number(age),
        Number(user_health.BMI),
        Number(user_health.hbA1c),
        user_info.gender
      ),
    }));

    // Ensure temp_payload is correctly formatted as per the API's expectations
    const formattedPayload = {
      Data: temp_payload,
    };

    const response = await axios.post(
      "https://895f-39-60-249-131.ngrok-free.app/predict_model_02",
      formattedPayload
    );

    const topFoods = getTopRecommendedFoods(response.data.Data, 9, 25, 15);

    const topFoodNames = topFoods.map((food) => food.name);

    // Fetch nutritional details from the database for the top foods
    const placeholders = topFoodNames.map(() => "?").join(",");
    const [rows] = await db.query(
      `SELECT food_name, \`carbs (g)\` as carbs, \`fats (g)\` as fats, \`proteins (g)\` as proteins, \`energy (kCal)\` as energy 
         FROM Foods 
         WHERE food_name IN (${placeholders})`,
      topFoodNames
    );

    const foodDetails = rows.reduce((acc, row) => {
      acc[row.food_name] = {
        carbs: row.carbs,
        fats: row.fats,
        proteins: row.proteins,
        cal: row.energy,
      };
      return acc;
    }, {});

    // Extract the details for the top recommended foods
    const topCarbs = topFoodNames.map((name) => foodDetails[name].carbs);
    const topFats = topFoodNames.map((name) => foodDetails[name].fats);
    const topProteins = topFoodNames.map((name) => foodDetails[name].proteins);
    const topCalories = topFoodNames.map((name) => foodDetails[name].cal);
    const topPredictions = topFoods.map((food) => food.score);

    // Construct the final JSON structure
    const payload_2 = {
      "Top RecScore": {
        food_names: topFoodNames,
        predictions: topPredictions,
        carbs: topCarbs,
        fats: topFats,
        Proteins: topProteins,
        cal: topCalories,
      },
    };

    return res.status(200).send({
      success: true,
      message: "Meal Plans generated successfully.",
      data: payload_2,
    });
  } catch (e) {
    console.error(e);
    return res.status(500).send({
      success: false,
      message: "Error in Generate Meal Plan API.",
    });
  }
};

const storeMealPlan = async (req, res) => {
  try {
    const user_id = req.params.id;
    if (!user_id) {
      return res.status(400).send({
        success: false,
        message: "User ID not provided.",
      });
    }
    const { mealDetails } = req.body;
    if (!mealDetails) {
      return res.status(400).send({
        success: false,
        message: "No data in request body.",
      });
    }

    const mealPlanValues = mealDetails.map((meal) => [
      meal.food_name,
      user_id,
      meal.score,
      meal.fats,
      meal.carbs,
      meal.protein,
      meal.portion_size,
      meal.meal_time,
      meal.calories,
    ]);

    const query = `
      INSERT INTO MealPlans (
        food_name, user_id, score, fats, carbs, protein, portion_size, meal_time, calories
      ) VALUES ?
    `;
    console.log(mealPlanValues);
    const result = db.query(query, [mealPlanValues]);
    return res.status(200).send({
      success: true,
      message: "Meal Plan Stored Successfully.",
      result,
    });
  } catch (e) {
    return res.status(500).send({
      success: false,
      message: "Error Storing Meal Plan",
      error: e,
    });
  }
};

const storeCals = async (req, res) => {
  try {
    const user_id = req.params.id;
    if (!user_id) {
      return res.status(400).send({
        success: false,
        message: "User ID not provided.",
      });
    }
    const { consumed_calories } = req.body;
    if (!consumed_calories) {
      return res.status(400).send({
        success: false,
        message: "Consumed Calories not provided.",
      });
    }
    const result = await db.query(
      "UPDATE HealthProfile SET consumed_calories = ? WHERE user_id = ?",
      [consumed_calories, user_id]
    );
    if (!result) {
      return res.status(400).send({
        success: false,
        message: "Couldn't store Consumed Calories.",
      });
    }

    return res.status(200).send({
      success: true,
      message: "Successfully stored calories.",
    });
  } catch (e) {
    return res.status(500).send({
      success: false,
      message: "Error in Store Calories API",
      error: e,
    });
  }
};

const checkMealPlan = async (req, res) => {
  const user_id = req.params.id;
  if (!user_id) {
    return res.status(400).send({
      success: false,
      message: "No User ID provided.",
    });
  }

  try {
    const today = new Date().toLocaleDateString("en-CA", {
      timeZone: "Asia/Karachi",
    });

    const mealPlans = await db.query(
      "SELECT date FROM MealPlans WHERE user_id = ?",
      [user_id]
    );

    console.log(today, mealPlans);

    if (mealPlans.length > 0) {
      const hasMealPlanForToday = mealPlans[0].some((plan) => {
        const planDate = new Date(plan.date);
        const planDatePKT = planDate.toLocaleDateString("en-CA", {
          timeZone: "Asia/Karachi",
        });
        console.log(planDatePKT);
        return planDatePKT === today;
      });

      if (hasMealPlanForToday) {
        return res.status(400).send({
          success: false,
          message: "Meal plan already exists for today.",
        });
      }
    }

    res.status(200).send({
      success: true,
      message: "You can generate a new meal plan.",
    });
  } catch (error) {
    console.error(error);
    res.status(500).send({
      success: false,
      message: "An error occurred while checking meal plans.",
    });
  }
};

const getMealPlan = async (req, res) => {
  try {
    const user_id = req.params.id;
    if (!user_id) {
      return res.status(400).send({
        success: false,
        message: "User ID not provided.",
      });
    }
    console.log(user_id)
    const today = new Date().toLocaleDateString("en-CA", {
      timeZone: "Asia/Karachi",
    });

    const [mealPlan] = await db.query(
      "SELECT * FROM MealPlans WHERE user_id=?",
      [user_id, today]
    );

    if (!mealPlan) {
      return res.status(400).send({
        success: false,
        message: "No Meal Plan Found.",
      });
    }

    return res.status(200).send({
      success: true,
      message: "Meal Plan found.",
      data: mealPlan,
    });
  } catch (e) {
    return res.status(500).send({
      success: false,
      message: "Error in Get Meal Plan API.",
      e,
    });
  }
};

module.exports = {
  MealPlanMobile,
  generateMealPlan,
  storeMealPlan,
  storeCals,
  checkMealPlan,
  getMealPlan,
};
