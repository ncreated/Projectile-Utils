package {
    import nape.geom.Vec2;

    /**
     *
     * @author maciek grzybowski, 03.11.2013 23:11
     *
     */
    public class SimulationController {

        private var _model:SimulationModel;
        private var _view:SimulationView;


        public function SimulationController(model:SimulationModel, view:SimulationView) {
            _model = model;
            _view = view;
            _view.clicked.add(onViewClicked);
            _model.targetPositionChanged.add(updateTrajectory);
            _model.stepTimeChanged.add(updateTrajectory);
            _model.stepsChanged.add(updateTrajectory);
            _model.velocityChanged.add(updateTrajectory);
            _model.trajectoryChanged.add(updateTrajectory);
            _model.gravityChanged.add(updateTrajectory);
        }

        public function update(dt:Number):void {
            _model.space.step(dt);
            _view.drawSpace(_model.space);
        }

        private function onViewClicked(x:Number, y:Number):void {
            if (_model.state == SimulationModel.STATE_LAUNCHED) {
                _model.state = SimulationModel.STATE_AIM;
            }
            _model.setTargetPosition(x, y);
        }

        private function updateTrajectory():void {
            _view.clearTrajectories();

            var x:Number = _model.targetPosition.x - _model.body.position.x;
            var y:Number = -(_model.targetPosition.y - _model.body.position.y);// change sign to invert flash coordinates system
            var gravity:Number = _model.gravity.y;// notice: gravity is greater than 0
            var velocity:Number = _model.velocity;

            if (ProjectileUtils.canHitCoordinate(x, y, velocity, gravity)) {
                var angle1:Number = ProjectileUtils.calculateAngle1ToHitCoordinate(x, y, velocity, gravity);
                var angle2:Number = ProjectileUtils.calculateAngle2ToHitCoordinate(x, y, velocity, gravity);

                var sign:Number = x > 0 ? 1 : -1;
                var v1:Vec2 = new Vec2(sign * Math.cos(angle2) * velocity, -sign * Math.sin(angle2) * velocity);// "-" for y component inverts velocity back for flash coordinates system
                var v2:Vec2 = new Vec2(sign * Math.cos(angle1) * velocity, -sign * Math.sin(angle1) * velocity);

                _view.drawTrajectory(_model.body.position, v1, _model.gravity, _model.steps, _model.stepTime, 0x00FA00);// green
                _view.drawTrajectory(_model.body.position, v2, _model.gravity, _model.steps, _model.stepTime, 0x0099FF);// blue

                if (_model.trajectory == 0) _model.launchVelocity.set(v1);
                else _model.launchVelocity.set(v2);

                _model.alertMessage = "";
            }
            else {
                _model.launchVelocity.setxy(0, 0);
                _model.alertMessage = "Projectile cannot reach target with velocity of "+String(velocity)+". Increase velocity.";
            }

            _view.moveMarkerToPosition(_model.targetPosition.x, _model.targetPosition.y);
        }
    }
}
