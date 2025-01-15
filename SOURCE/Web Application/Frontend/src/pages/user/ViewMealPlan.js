import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { Box, Card, CardContent, Typography, Grid, CircularProgress, Divider } from '@mui/material';
import { motion } from 'framer-motion';
import axios from 'axios';

const ViewMealPlan = () => {
  const { id } = useParams(); // Get user ID from route parameters
  const [mealPlans, setMealPlans] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    axios
      .get(`http://localhost:3001/api/user/mealplans/get/${localStorage.getItem('id')}`, {
        headers: {
          Authorization: `${localStorage.getItem('token')}`
        }
      })
      .then((response) => {
        if (response.data.success) {
          const data = Array.isArray(response.data.data) ? response.data.data : [response.data.data];
          setMealPlans(data);
        } else {
          setError(response.data.message);
        }
        setLoading(false);
      })
      .catch((error) => {
        console.error('API error:', error);
        setError('An error occurred while fetching the meal plans. Please try again later.');
        setLoading(false);
      });
  }, [id]);

  if (loading) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" height="100vh">
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Box display="flex" justifyContent="center" alignItems="center" height="100vh">
        <Typography variant="h6" color="error">
          {error}
        </Typography>
      </Box>
    );
  }

  return (
    <Box sx={{ flexGrow: 1, p: { xs: 2, sm: 4 }, backgroundColor: '#f5f5f5' }}>
      <Typography variant="h2" component="h1" sx={{ mb: 8, textAlign: 'center', color: '#333', fontWeight: 'bold', fontFamily: 'Arial' }}>
        Today&apos;s Meal Plan
      </Typography>
      <Grid container spacing={3} justifyContent="center">
        {mealPlans.map((meal, index) => (
          <Grid item key={index} xs={12} sm={6} md={4}>
            <motion.div
              initial={{ opacity: 0, y: 50 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              whileHover={{ scale: 1.02 }}
            >
              <Card
                variant="outlined"
                sx={{
                  borderRadius: 4,
                  boxShadow: '0px 4px 20px rgba(0, 0, 0, 0.1)',
                  background: 'linear-gradient(135deg, #ffffff 30%, #f9f9f9 100%)',
                  border: '1px solid #6ea393',
                  overflow: 'hidden',
                  position: 'relative',
                  '&:before': {
                    content: '""',
                    position: 'absolute',
                    top: -10,
                    right: -10,
                    bottom: -10,
                    left: -10,
                    background: 'linear-gradient(45deg, #6ea393, #84d4a4)',
                    zIndex: -1,
                    filter: 'blur(15px)',
                    opacity: 0.5
                  },
                  '&:hover': {
                    boxShadow: '0px 12px 40px rgba(0, 0, 0, 0.2)',
                    transition: 'all 0.3s ease-in-out'
                  }
                }}
              >
                <CardContent sx={{ position: 'relative', zIndex: 1 }}>
                  <Typography variant="h5" component="h2" sx={{ mb: 2, color: '#6ea393', fontWeight: 'bold', fontSize: '1.25rem' }}>
                    {meal.food_name}
                  </Typography>
                  <Divider sx={{ mb: 2, backgroundColor: '#6ea393', height: '2px' }} />
                  <Typography variant="body1" component="p" sx={{ mb: 1 }}>
                    <strong>Score:</strong> {meal.score}
                  </Typography>
                  <Typography variant="body1" component="p" sx={{ mb: 1 }}>
                    <strong>Fats:</strong> {meal.fats}g
                  </Typography>
                  <Typography variant="body1" component="p" sx={{ mb: 1 }}>
                    <strong>Carbs:</strong> {meal.carbs}g
                  </Typography>
                  <Typography variant="body1" component="p" sx={{ mb: 1 }}>
                    <strong>Protein:</strong> {meal.protein}g
                  </Typography>
                  <Typography variant="body1" component="p" sx={{ mb: 1 }}>
                    <strong>Portion Size:</strong> {meal.portion_size}g
                  </Typography>
                  <Typography variant="body1" component="p" sx={{ mb: 1 }}>
                    <strong>Meal Time:</strong> {meal.meal_time}
                  </Typography>
                  <Typography variant="body1" component="p" sx={{ mb: 1 }}>
                    <strong>Calories:</strong> {meal.calories}kcal
                  </Typography>
                </CardContent>
              </Card>
            </motion.div>
          </Grid>
        ))}
      </Grid>
    </Box>
  );
};

export default ViewMealPlan;
