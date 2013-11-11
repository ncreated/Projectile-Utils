package {

    /**
     * Projetile trajectory utils.
     * @author maciek grzybowski, 10.11.13 14:29
     *
     */
    public class ProjectileUtils {

        /**
         * Checks if projectile can hit (x, y) coordinate with initial velocity length under given gravity.
         * @param x
         * @param y
         * @param velocity initial velocity
         * @param gravity gravity value; should be greater than 0
         * @return
         */
        public static function canHitCoordinate(x:Number, y:Number, velocity:Number, gravity:Number):Boolean {
            return calculateDelta(x, y, velocity, gravity) >= 0;
        }

        /**
         * Calculates angle to hit given (x, y) coordinate with given velocity and gravity.
         * @param x
         * @param y
         * @param velocity initial velocity
         * @param gravity gravity value; should be greater than 0
         * @return angle in radians
         */
        public static function calculateAngle1ToHitCoordinate(x:Number, y:Number, velocity:Number, gravity:Number):Number {
            if (x == 0) return y > 0 ? -Math.PI * 0.5 : Math.PI * 0.5;
            var delta:Number = calculateDelta(x, y, velocity, gravity);
            var sqrtDelta:Number = Math.sqrt(delta);
            return Math.atan((velocity * velocity - sqrtDelta)/(gravity * x));;
        }

        /**
         * Calculates angle to hit given (x, y) coordinate with given velocity and gravity.
         * @param x
         * @param y
         * @param velocity initial velocity
         * @param gravity gravity value; should be greater than 0
         * @return angle in radians
         */
        public static function calculateAngle2ToHitCoordinate(x:Number, y:Number, velocity:Number, gravity:Number):Number {
            if (x == 0) return -Math.PI * 0.5;
            var delta:Number = calculateDelta(x, y, velocity, gravity);
            var sqrtDelta:Number = Math.sqrt(delta);
            return Math.atan((velocity * velocity + sqrtDelta)/(gravity * x));
        }

        private static function calculateDelta(x:Number, y:Number, velocity:Number, gravity:Number):Number {
            return velocity * velocity * velocity * velocity - gravity * (gravity * x * x + 2 * y * velocity * velocity)
        }
    }
}
