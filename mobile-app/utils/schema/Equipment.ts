import { z } from 'zod';

export const EquipmentSchema = z.object({
  id: z.string().uuid(),
  name: z.string(),      // e.g., Dumbbell, Barbell, Kettlebell, Lat Pulldown Machine
  category: z.string(),      // e.g., Machine, Free Weight, Bodyweight, Cable
});

export type Equipment = z.infer<typeof EquipmentSchema>;