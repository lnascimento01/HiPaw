import '../core/ui/widgets/hi_paws_exercise_card.dart';
import '../models/exercise.dart';

class ExerciseCard extends HiPawsExerciseCard {
  const ExerciseCard({super.key, required Exercise exercise})
      : super(exercise: exercise);
}
