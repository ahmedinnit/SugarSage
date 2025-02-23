import { Box /* Typography */ } from '@mui/material';
import NavGroup from './NavGroup';
import adminMenuItem from 'menu-items/admin';
import userMenuItem from 'menu-items/user';

// ==============================|| DRAWER CONTENT - NAVIGATION ||============================== //

const Navigation = () => {
  const role = localStorage.getItem('role');
  const menuItem = role == 'admin' ? adminMenuItem : userMenuItem;
  const navGroups = menuItem.items.map((item) => {
    switch (item.type) {
      case 'group':
        return <NavGroup key={item.id} item={item} />;
      // default:
      //   return (
      //     <Typography key={item.id} variant="h6" color="error" align="center">
      //       Fix - Navigation Group
      //     </Typography>
      //   );
    }
  });

  return <Box sx={{ pt: 2 }}>{navGroups}</Box>;
};

export default Navigation;
