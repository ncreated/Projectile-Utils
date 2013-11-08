package {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;

    import nape.geom.Vec2;

    import nape.space.Space;

    import nape.util.BitmapDebug;

    import org.osflash.signals.Signal;

    /**
     *
     * @author maciek grzybowski, 03.11.2013 21:56
     *
     */
    public class SimulationView extends Sprite {

        private var _drawRect:Rectangle;

        private var _bitmapDebug:BitmapDebug;
        private var _trajectoryPath:Sprite;
        private var _marker:Sprite;

        private var _clicked:Signal;

        public function SimulationView(rect:Rectangle) {
            _drawRect = rect;

            _bitmapDebug = new BitmapDebug(rect.width, rect.height, 0x000000, false);
            _bitmapDebug.display.x = rect.x;
            _bitmapDebug.display.y = rect.y;
            addChild(_bitmapDebug.display);

            _trajectoryPath = new Sprite();
            _trajectoryPath.x = rect.x;
            _trajectoryPath.y = rect.y;
            addChild(_trajectoryPath);

            _marker = new Sprite();
            _marker.graphics.lineStyle(2, 0xFF0000);
            _marker.graphics.moveTo(-3, -3);
            _marker.graphics.lineTo(3, 3);
            _marker.graphics.moveTo(-3, 3);
            _marker.graphics.lineTo(3, -3);
            _marker.mouseEnabled = false;
            addChild(_marker);

            _clicked = new Signal(Number, Number);
            addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
        }

        public function drawSpace(space:Space):void {
            _bitmapDebug.clear();
            _bitmapDebug.draw(space);
            _bitmapDebug.flush();
        }

        public function drawTrajectory(begin:Vec2, velocity:Vec2, gravity:Vec2, steps:int, step_time:Number):void {
            _trajectoryPath.graphics.clear();
            _trajectoryPath.graphics.lineStyle(2, 0xEFEF39, 0.3);
            _trajectoryPath.graphics.moveTo(begin.x, begin.y);

            var point:Vec2;
            for (var i:int = 0; i <= steps; i++) {
                point = getTrajectoryPoint(begin, gravity, velocity, i, step_time);
                _trajectoryPath.graphics.lineTo(point.x, point.y);
            }
        }

        public function moveMarkerToPosition(x:Number, y:Number):void {
            _marker.x = x;
            _marker.y = y;
        }

        private function getTrajectoryPoint(begin:Vec2, gravity:Vec2, velocity:Vec2, step:int, step_time:Number):Vec2 {
            var stepVelocity:Vec2 = velocity.mul(step_time);
            var stepGravity:Vec2 = gravity.mul(step_time * step_time);

            var c2:Vec2 = stepVelocity.mul(step);
            var c3:Vec2 = stepGravity.mul((step * step + step) * 0.5);

            return begin.add(c2).add(c3);
        }

        // signals

        public function get clicked():Signal {
            return _clicked;
        }

        // mouse events

        private function onClick(event:MouseEvent):void {
            if (_drawRect.contains(event.localX, event.localY)) {
                _clicked.dispatch(event.localX, event.localY);
            }
        }
    }
}
