#!/bin/sh
name=$1

function getCamelCase() {
	echo "${name}" | perl -pe 's/(^|-)([a-z])/uc($2)/ge'
}

function getLowerCamelCase() {
	echo "${name}" | perl -pe 's/(-)([a-z])/uc($2)/ge'
}

function getUpperCase() {
	echo "${name}" | tr - _  | tr '[:lower:]' '[:upper:]'
}

function getTemplatePath() {
	path=$(pwd)
	echo ${path/*\static/\/static}
}

camelCase=$(getCamelCase)
lowerCamelCase=$(getLowerCamelCase)
upperCase=$(getUpperCase)
htmlPath=$(getTemplatePath)

#create folder
mkdir ${name}
cd ${name}

#create scss file
scss="__${name}.scss" 
cat > ${scss} << END
.${name}--component {

}
END

#create controller file
com="${name}.controller.js"
cat > ${com} << END
let SERVICES;

class ${camelCase}Controller {
    constructor() {
        SERVICES = {
            
        };
    }

    \$onInit() {

    }
}

${camelCase}Controller.\$inject = [''];
export default ${camelCase}Controller;
END

#create component file
con="${name}.component.js"
cat > ${con} << END
import ${camelCase}Controller from "./${name}.controller";

export const ${upperCase}_COMPONENT_NAME = '${lowerCamelCase}';

export const ${camelCase}Component = {
    templateUrl: '${htmlPath}/${name}/${name}.html',
    replace: true,
    bindings: {},
    controller: ${camelCase}Controller
};
END

#create HTMl file
html="${name}.html"
cat > ${html} << END
<div class="${name}--component">

</div>
END

#create spec file
spec="${name}.spec.js"
cat > ${spec} << END
import ${camelCase}Controller from "./${name}.controller.js"

describe('', function () {
    let scope, httpMock, rootScope, ctrl;

    beforeEach(function () {
        angular.module('unifi').controller("${camelCase}Controller", ${camelCase}Controller);
    });
    
    beforeEach(angular.mock.module('unifi'));
    
    beforeEach(angular.mock.module('unifi.services'));
    
    beforeEach(angular.mock.module('unifi.factories'));
    
    beforeEach(angular.mock.inject(function (_\$httpBackend_, RootService, \$controller) {
        scope = RootService.new();
        httpMock = _\$httpBackend_;
        rootScope = RootService;
        
        ctrl = \$controller('${camelCase}Controller', {
            \$scope: scope,
            RootService: rootScope
        });

    }));
});
END