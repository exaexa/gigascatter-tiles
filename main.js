import 'ol/ol.css';
import Map from 'ol/Map';
import TileLayer from 'ol/layer/Tile';
import View from 'ol/View';
import XYZ from 'ol/source/XYZ';

var map = new Map({
  target: 'map',
  layers: [
    new TileLayer({
      source: new XYZ({
        url: 'http://localhost:8080/{z}/{y}/{x}.png'
      }),
    }) ],
  view: new View({
    center: [0, 0],
    zoom: 1,
  }),
});
